class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.9.0.tar.gz"
  sha256 "a4c68cd2f3633f1478dc22ac5f27c636de236fdfe6641f558d65b846d1fbe1c8"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  depends_on "rust" => :build
  depends_on "neovim"

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "python@3.10" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    if OS.mac?
      # https://github.com/burtonageo/cargo-bundle/issues/118
      with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
      prefix.install "target/release/bundle/osx/Neovide.app"
      bin.install_symlink prefix/"Neovide.app/Contents/MacOS/neovide"
    else
      bin.install "target/release/neovide"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")

    test_server = "localhost:#{free_port}"
    nvim_pid = spawn "nvim", "--headless", "--listen", test_server
    sleep 10
    neovide_pid = spawn bin/"neovide", "--nofork", "--remote-tcp=#{test_server}"
    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
