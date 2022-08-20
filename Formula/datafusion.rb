class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/11.0.0.tar.gz"
  sha256 "2a52f106875919eb2faf64d3f6db9e8a1426447aa578bccc0dfcd2f540d0bcf3"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91965408d8640a9460e9556951ef9f270fa1ef99d5f0bb6a9a79053ba31b14b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b250285fe56e74697f6da4589a8b90ce8357fa1e253136b6e049d76cff755bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "030d1c76aabdc29cbb29c8538512ea5dd6e0518761a7097854ae28530893a8d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "470fbc9ceeedaa7aaf778431bb66d5ec385aca2c4e3a2817b5fcc205f8f4ab1b"
    sha256 cellar: :any_skip_relocation, catalina:       "917bd5ffb5cb9bb4ab97fa5cf9931517f26dfdf1782408dfd38ae0eb6ea1a1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e44c2e6e0abc18675db52ab52657ce8c6efbeb5e686859cfa59a33b94d4c901c"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
