class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e7ed8559b3d9ac872b6633bb2e11c91aad69d7399568a300cbf2c3d2f97c7d2a"
  license "MIT"
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "082243e05496c2b78edf9e0327663236d5ba2beb21d47615bff6bb742e285958"
    sha256 cellar: :any_skip_relocation, big_sur:       "1640a1aeba079a87f05cb97386a2bd154143559bce7fb86461191693c9de40fc"
    sha256 cellar: :any_skip_relocation, catalina:      "8851765dfa64f6e3ec6b65c83e8f6db7c3103f3f10f928438d4df3bcd318f472"
    sha256 cellar: :any_skip_relocation, mojave:        "dd0873e9bf03784e0fecde129ffabe9dd03ce3486832d9a5be7b53f7d29ebfc2"
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
