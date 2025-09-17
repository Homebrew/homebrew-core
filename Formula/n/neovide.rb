class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.15.1.tar.gz"
  sha256 "9042678f2fa33a86662755b3d37f7b264ebbf28b9a5f021ca89c137faeeda37d"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a353bf0c06e9848e02714039184884029f383e42ff4d84a63e59267b5772a46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08fd54b4c43582bd0f6e043ca65f227a1de29a81208ca3507f8a86f7199c629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d06535abaf109688ff50870ef514838a2d7fa800a239bc5af5285c6aa1043e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42d229838f126c492755560d495cd18dc78d817c8fb421a54896da2e6e5dd7d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d3c2012e42e2eb885e8069a2a76d4ae2e2d6e83c329a1bab45f3e39ee256dc"
    sha256 cellar: :any_skip_relocation, ventura:       "2707d9fa16541dc71a43476400e6e4a00c5fe65a6236dab9bbc0497ac2a51852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122cb9188977603d27d7afef9214c627f3a35f080cee94a93dc80f4cd05b314d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6547720ec1876a2f4a2fa9c4acb23eba4656c7f1a58698940e0b50e53d113306"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "harfbuzz"
    depends_on "icu4c@77"
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
