class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.15.2.tar.gz"
  sha256 "a8179c461d41277b41692edcae64af6d1c80454aafff608af0268c5abca95b5c"
  license "MIT"
  revision 1
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc3c1b70d73e5b021480db2b0443600703f16e5ec1b52d4135d8d41c0d55186b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117679e168231321d8447464c15579a50e197c962879bb146c445861c6c71bf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5fb0b7546d5b35fb6318ba89a5e7a943116c22cbd6ed059d54d93e34a1302e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e3d1b2500c1e5fd422814f8cec203172457a6ceda246873f7adced0e60ebdb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66a170728606d26271bbb98d9707847a6b31b6ccb22cb46af69d8957683100b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65507179c2ec993fa6c6922104aa8743f2ff0c13d57fddaf840847ea76e087f9"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@78"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    # `libxcursor` is loaded when using X11 (DISPLAY) instead of Wayland (WAYLAND_DISPLAY).
    # Once https://github.com/rust-windowing/winit/commit/aee95114db9c90eef6f4d895790552791cf41ab9
    # is in a `winit` release, check `lsof -p <neovide-pid>` to see if dependency can be removed
    depends_on "libxcursor"
    depends_on "libxkbcommon" # dynamically loaded by xkbcommon-dl
    depends_on "mesa" # dynamically loaded by glutin
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "Skia build uses clang target option"
  end

  def install
    ENV["FORCE_SKIA_BUILD"] = "1" # avoid pre-built `skia`

    # FIXME: On macOS, `skia-bindings` crate only allows building `skia` with bundled libraries
    if OS.linux?
      ENV["SKIA_USE_SYSTEM_LIBRARIES"] = "1"
      ENV["CLANG_PATH"] = which(ENV.cc) # force bindgen to use superenv clang to find brew libraries

      # GN doesn't use CFLAGS so pass extra paths using superenv
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["freetype"].opt_include/"freetype2"
      ENV.append_path "HOMEBREW_INCLUDE_PATHS", Formula["harfbuzz"].opt_include/"harfbuzz"
    end

    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https://github.com/burtonageo/cargo-bundle/issues/118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "target/release/bundle/osx/Neovide.app"
    rm bin/"neovide" # Remove the original binary first
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  def nvim_connected_clients_count(socket)
    Utils.safe_popen_read(
      "nvim", "--headless",
              "--server", socket,
              "--remote-expr", 'luaeval("vim.tbl_count(vim.api.nvim_list_chans()) - 1")'
    ).chomp.to_i
  end

  test do
    socket = testpath/"nvim.sock"
    nvim_cmd = ["nvim", "--headless", "-i", "NONE", "-u", "NONE", "--listen", socket]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 1 until socket.exist? && socket.socket?

    neovide_cmd = [bin/"neovide", "--no-fork", "--server=#{socket}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 1 until nvim_connected_clients_count(socket).positive?
    system "nvim", "--server", socket, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
