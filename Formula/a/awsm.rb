class Awsm < Formula
  desc "CLI tool to simplify working with AWS profiles, credentials, and sessions"
  homepage "https://github.com/AleG03/awsm"
  url "https://github.com/AleG03/awsm/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "6661562edf91353afeab4d9a7fbe5398eae86399825c0967452307811afa8547"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "AWSM - AWS Manager", shell_output("#{bin}/awsm --help")
  end
end
