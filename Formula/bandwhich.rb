class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.10.0.tar.gz"
  sha256 "33966794c8689a4d6e16bf1c8e615377ed58773bf653ac547e109b0cce12a705"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a704f59e45065c86f8135e101cd2e93cefb81fa15726aa3d353b08ac9c1da10" => :catalina
    sha256 "981b0b48cb17df8bffd453236c29f884a1e263892e5868b6c0a556d9636c7c06" => :mojave
    sha256 "cdf28f0dabc96477d098c4df4135ab851e117c6c6ff00499f2ccd9ea4cecde5f" => :high_sierra
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
