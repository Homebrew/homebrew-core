class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey/archive/v0.1.4.tar.gz"
  sha256 "944097e62dd0bd5012d3b355d9fe2e7b7afcf13cc0b2c06151e0f4c2babfc279"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "833f09f5322dd41cc3438f9880d557941652073d02acc2971181aa1c5b4f6a7d" => :catalina
    sha256 "902d975f8dbc7f27890d56eed1a377bd880225b6860e2e7db6fed4f03e58c077" => :mojave
    sha256 "2111023b9742683d7beb4c1383f59daff60fe019ffcf5fbc91d9e3f68386dc5f" => :high_sierra
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
