class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.4.tar.gz"
  sha256 "82e87aaf0664fb1447b84b9f1a6b55f33f54c5a64d25dc6d8e64fc28bde66223"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d80fb9752976dbb7269b2fdbcf927431ffddda6784c418bf1b6366c4c145894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af5057524986872dd201e5e8ace2702a3e12dfbaf5370b2ca482b4fb9ef950a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc0157631e4a0e5127b0c473a3348af074927bb8bab9ad136c419afb31482c9"
    sha256 cellar: :any_skip_relocation, ventura:        "68035dd86e1f64b12b7cc0884e8ea83a80f24d1629a52ff5711ba37ce8f72701"
    sha256 cellar: :any_skip_relocation, monterey:       "acd07821f8c42ec3bce292585368ee8ff7182afa55ee5b8d2f160f119c4c0bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "27ed41da4fc0c6c8585553cbb5ac85ed4278ca2f7c3112b656a5e9cd8ac8ac41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "045fc0e33774d21929ab127e97aa3b5b84b001a292aa4d5dfb0b5cff1d347a1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
