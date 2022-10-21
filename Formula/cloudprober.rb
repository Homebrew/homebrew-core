class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "e2289eaad263e35e20ed3afaccf4c854df179de4e36aa705fcf106d93a352b0b"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cloudprober --version").strip
  end
end
