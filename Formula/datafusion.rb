class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/20.0.0.tar.gz"
  sha256 "3aabd205d3d571facc558a713a89ca1ceae2d73bf74b30c5ed8db9828541ad28"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb593042d0caf708836baa158f591913a2581f3211636a99a2970427b7cf42f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4922781aedffe9741e9ae6b1bf7e918132a0c9e51c7d173d63b8450dba34376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f55b6c36d2026abb3979ba203791b3ac9090767806c97d5c60f1ffaa19612b98"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ac496bd37a1491dec95a4e36f2a714293077dbc3c6759c3239854ceda07cd8"
    sha256 cellar: :any_skip_relocation, monterey:       "cf67e0120b788d8841b4c696d38cde3fddcfcf63cca9f8940ed8b89fe0497426"
    sha256 cellar: :any_skip_relocation, big_sur:        "89a6daf890193f04e0adb90e382c918d32c60c0166c582cbe1f11ca441e8713d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b22ff3a31d3cc05aacc511420a1c3b63fa534a8a5c7d80ba680e57d8ccea2d"
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
