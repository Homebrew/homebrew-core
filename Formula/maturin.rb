class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "e6a9a67cc62ffe248654e60e7ec211bf23319c4c936ad87022f7a1fd0997430d"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

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
