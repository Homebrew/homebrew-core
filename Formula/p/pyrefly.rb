class Pyrefly < Formula
  desc "Fast type checker and IDE for Python"
  homepage "https://pyrefly.org/"
  url "https://github.com/facebook/pyrefly/archive/refs/tags/0.18.0.tar.gz"
  sha256 "fcc7529c577d6d8e9fcc53387b2af5c7252e41baba434a591b0c6dc4a35cc51c"
  license "MIT"
  head "https://github.com/facebook/pyrefly.git", branch: "main"

  depends_on "rustup" => :build

  def install
    # rustup is keg-only in Homebrew, so we need to add it to PATH
    ENV.prepend_path "PATH", Formula["rustup"].opt_bin
    
    # Install the required nightly toolchain
    system "rustup", "toolchain", "install", "nightly-2025-03-29"
    
    # Set the toolchain for this build
    ENV["RUSTUP_TOOLCHAIN"] = "nightly-2025-03-29"
    
    # Set JEMALLOC configuration for ARM builds
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm?
    
    system "cargo", "install", *std_cargo_args(path: "pyrefly")
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/pyrefly --version")
    
    # Test basic functionality with a simple Python file
    (testpath/"test.py").write <<~PYTHON
      def hello(name: str) -> str:
          return f"Hello, {name}!"
      
      result = hello("world")
    PYTHON
    
    # Run pyrefly check command
    shell_output("#{bin}/pyrefly check #{testpath}/test.py")
  end
end
