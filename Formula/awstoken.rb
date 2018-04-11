class Awstoken < Formula
  desc "Bash wrapper for awscli for temporary security credential generation"
  homepage "https://github.com/vandot/awstoken"
  url "https://github.com/vandot/awstoken/archive/v0.1.0.tar.gz"
  sha256 "6c8389c344dcdb9455e4d8bbddaa41de5d2cb6681d2d947bcbf01501bc4a458e"
  depends_on "awscli"
  depends_on "jq"

  def install
    bin.install "awstoken"
  end

  test do
    system "#{bin}/awstoken", "--help"
  end
end
