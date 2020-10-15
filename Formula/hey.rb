class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey/archive/v0.1.4.tar.gz"
  sha256 "944097e62dd0bd5012d3b355d9fe2e7b7afcf13cc0b2c06151e0f4c2babfc279"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "972cc3f6a520467db11ab9cef3aa5311c6813c203c23bb0173363a00a45cfc07" => :catalina
    sha256 "af9934ac04900c142879a97bcc9b376e25f4928239c0bb9bd68fdad0e4174ead" => :mojave
    sha256 "67fbe5a4b3574ea9025607e02b56c49572d4f184bcf1ae49fb5cb3eb05ede26c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end
