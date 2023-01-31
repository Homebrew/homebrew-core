class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/17.0.0.tar.gz"
  sha256 "8a1e92587129793e90be5c97690eeb14e78979b9c75908e8e1d1b79401736e1b"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d285d5450298cb75562e0910c2d77bed54ac8b5e378109a8652def84bff9e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f206fa1e50ef31fe71de02a419743ab89a3ea4456f16e66ad2389a86fe791c01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca41a0c72e245c790034cb46f23fd7bd6f4746978576781bae07d543ea5b2e7"
    sha256 cellar: :any_skip_relocation, ventura:        "12a9cba07ce3bb3e0b67358320bf4f8a917e48ac92154ff5e9f4a7ee81621a41"
    sha256 cellar: :any_skip_relocation, monterey:       "235612c7594ad29b177b62a64df90b3adde73d63d89433cc805c84de11a3ac17"
    sha256 cellar: :any_skip_relocation, big_sur:        "863c5f2a74d521612c8c36db2741801580e5978b3be0c60a0e8cb659f403b3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cecc000998ae082a0bd6af9141fdbdc91272514a7951225680c555fe566c0b32"
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
