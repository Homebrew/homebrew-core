class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.8.0.tar.gz"
  sha256 "87dfe3f749b7e04b62e0bbfcbe98e02df16b92c84a55fb70993d9b31f57efb4b"

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
