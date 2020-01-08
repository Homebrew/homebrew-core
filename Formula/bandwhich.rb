class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.7.0.tar.gz"
  sha256 "6f08b0e1bf07fc8397bf9d4c5e8211368dbbcad4c0cfc2c369066f711a343152"

  bottle do
    cellar :any_skip_relocation
    sha256 "de672cda260bbc24b82f72405d3b7dc33b75f966dc46d52f48c5eee48a5376fe" => :catalina
    sha256 "5bfeb1d3bc8875c315a19a8f824de62beb74f2475be2aa4a6ce3663337a81a68" => :mojave
    sha256 "1a701120a7f38409071f308e40560ff793e81d69b184a812e76e960de82755df" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
