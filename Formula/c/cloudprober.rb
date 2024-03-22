class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "a666be1c5a2904df57464088114e44411cb4e0670c9f0f154e0bfbb5535457c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95c7bc767a7c28e3a6f8bea2022886f371c2b209f9558e57bea1050bfbab77ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ca5ec41f5e5fb0d2f1deba004dedf23ec7cf2af3d361e04cbe603d0650fe49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699334c5d403a95e459be42a54e6f5457ea37e3de14c66788adf0d5641012ae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7da12608d06440487834ab1609295e728ba18bcf9f3e00bcf454fdde3cc72d6"
    sha256 cellar: :any_skip_relocation, ventura:        "fc80b22ba0e88f883bc84902f52514691db7578c54c312b4ef6581fa5cb93f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "7c6e6485bab26d1fadbb4f29db0ebc0202e83ef1654fefcba0c53dab4cb9454b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94184cac2833f0c60ca99271cdcf0a8caab6567de9995d548a0bac4a14fc87d"
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
