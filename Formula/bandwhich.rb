class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.18.1.tar.gz"
  sha256 "01df14a34176858bdd11973898049350e608157f315e6248107475e75b0cafbc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "682f1c186b11e833d70994a013e8b80cda4b642ea46a8a3e05b8bbc9b8924aed" => :catalina
    sha256 "7139d8018a92ba27976d8bba7207bd19f221b90780c15c41eba1857f2d65cf3f" => :mojave
    sha256 "6dc8522efbc24509a80e5065dccae84da0bd5494506686e40fac663b197199b0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
