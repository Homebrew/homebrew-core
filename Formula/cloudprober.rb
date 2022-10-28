class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "e2289eaad263e35e20ed3afaccf4c854df179de4e36aa705fcf106d93a352b0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7c291e2c8c174b58ae6d0200f1ff4f9c69370a12d2b985a9a704eb37e47159"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819843e1539ed304e1fafd5546978ac17e76d7ab7f751c390d13abc8dbaefe23"
    sha256 cellar: :any_skip_relocation, monterey:       "1bce7d9b4f7d6caadd8ca62ec7fbf3a7aa01f94152b69850102ba5f115f76404"
    sha256 cellar: :any_skip_relocation, big_sur:        "8697aec934b0e4352c70019e64a75b7524f712951d3380d3003b682cfea54b3e"
    sha256 cellar: :any_skip_relocation, catalina:       "11b82badcb1fd165745d0e7c34bb5b0b899d9fb4185de891f7a15fa003c839ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4762a99ddec23cda5ac5d06d70f8ff547bb705eac4b650f1bc18fcb5c7f888"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      /Initialized status surfacer/.match?(line)
    end
  end
end
