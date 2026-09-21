class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "0a12517c9e69e279d392e642b9b9040b4f7013a0035e496b7e23f08e978c82c3"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7293d9e89a9b7fd9175f9f44a6d74f59b6f94eef3451d897967b7472101d5860"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b15dc8f8127d2ab035ec98791cd154d6065f58fde895c066591b9bdd9df67c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4442df6612be9a9aeb2363204499dcd3b651d1598e253c25b73d56acce18035e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd1429f2155fcc2c08448914f11df44ff30a23233fabfe3f72a80539a7947583"
    sha256 cellar: :any_skip_relocation, sonoma:            "f7d60d6810bffd5ac870ec76fe24d800458349d55987d97cf5d08557235b0b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1eea02a42fd51c04cbf37aad982fe690e258fa67d1119ae6ef16c8c056e07ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "02fa774371c89d65c8c1e382e5149736bebe8361823fc71c25af9f66975dcb21"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
