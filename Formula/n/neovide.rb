class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.16.2.tar.gz"
  sha256 "a2016cceab3cba50b6a8b2f6787ae9017a85923575e89a83ebb9d428e8f80ca9"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7708b2c0dd2a7e477cbf5356651356aeee272dbe3abacc43a5458ed791a49d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d745456e8e4fe4ae122473125fc4193912efc7a2bec54bef439c6f683099b176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a601edbdf48cd39c52325dcc0ece4c63015874b9a19664b4196edb84b43f5d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe2e463394919597829d82ecdb9d02971941bb8d75033e141e1563618761517e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1d67b6e85b580e3d47ff66029ef37a77df37f5f2ebd8e9d006eecb16bce34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363ff7bb4895c4626687bb96d9f1dac82d73e9a73853177854dec561c8ccab51"
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
    depends_on "xorg-server" => :test
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

  def nvim_ui_count(socket)
    Utils.safe_popen_read(
      "nvim", "--headless",
              "--server", socket,
              "--remote-expr", 'luaeval("vim.tbl_count(vim.api.nvim_list_uis())")'
    ).chomp.to_i
  end

  test do
    socket = testpath/"nvim.sock"
    nvim_cmd = ["nvim", "--headless", "-i", "NONE", "-u", "NONE", "--listen", socket]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 1 until socket.exist? && socket.socket?

    neovide_cmd = [bin/"neovide", "--no-fork", "--server=#{socket}"]
    neovide_cmd.unshift(Formula["xorg-server"].bin/"xvfb-run") if OS.linux? && ENV.exclude?("DISPLAY")
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 1 until nvim_ui_count(socket).positive?
    system "nvim", "--server", socket, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
