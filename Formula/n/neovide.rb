class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.15.2.tar.gz"
  sha256 "a8179c461d41277b41692edcae64af6d1c80454aafff608af0268c5abca95b5c"
  license "MIT"
  revision 1
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cd1ae192871c857c1bc7cfdc86dd0ed8d37e2bf468399297dfd2848f4897acd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7431a80ee963a89341748415cb400ca9c3b12b4c075e1c132a1249baf3cabade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb5a431e1f6433db53cf329ac0644741ee173328c47d6420f98771bb91c4215"
    sha256 cellar: :any_skip_relocation, sonoma:        "97c3ca622612e86cd722364c4f1f369a46be1a0bf0ec37fc871e4e1a73488ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f55132c2a8e2bd4a8147297727c1e9c10ce293822616fad48282b826067ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ca27a7dc416660e96bc0830c909bbf25d83fa3ec5cf14516ee3d39afe89ac4"
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
    depends_on "zlib"
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
