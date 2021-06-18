class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "e6a9a67cc62ffe248654e60e7ec211bf23319c4c936ad87022f7a1fd0997430d"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0b96d6bfd69d0b1726a021667888053153b9c4cc6cb254227ec9b0c185ddf233"
    sha256 cellar: :any_skip_relocation, big_sur:       "369ba476ac12b625603e681735bb3799c3792ab84fbf95f39487d0f2b68e1ee6"
    sha256 cellar: :any_skip_relocation, catalina:      "de6c2b01d717d2b5b425d8e3ac0ef9dde44db034f4ec47eefb8799b9562d45bf"
    sha256 cellar: :any_skip_relocation, mojave:        "adf82a913822b390f34720b5ca060ee28eabd427761e8b6414f639ffb8528eff"
  end

  depends_on "python@3.9" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    system "#{bin}/maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist"
    system "python3", "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system "python3", "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
