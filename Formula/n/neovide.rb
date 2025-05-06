class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://neovide.dev/"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.15.0.tar.gz"
  sha256 "89900673314f4dba66a1716197aca3b51f01365d9f8351563c3dc5604b3e48ab"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beadfba290080cf999c7cec2415e8e2000b6d3d2cd8d43be6acd235a97c57482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db047e1f2a6180d2bdf1341448f9f64c5414371fa5c33c664258d23bd803b11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71903190f94bd7018ecf017d70bc02e1dabdf795391cb2921831437ca58f3876"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f05f6186c0cb44b9f67c0968117cc157a081cbc8aefb24bfb6ec19c99ce63b"
    sha256 cellar: :any_skip_relocation, ventura:       "f89ba563de5b80e997b90c80e8efe1d03d4813de13ef0b70af325ac1392afc51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "441334ea72a94f2eb7fa628194f9730e15c38778001568b9afc00eab460ed7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2473d65387128d4bb25a636fee7200ef68cbf875cb0ba135cb54f7fe25a2cdae"
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
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin/"neovide", "--no-fork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
