class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "6bbcc560c8e0010cd045afa6558daaf186ae78cea2614ebec1d9afe94a30b9b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3138121c169a8a2af79d08bd41294ffff67f567e20a0cb5acfab4e320cd4e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1301b4d52b79e83b5804371c302d0c5dee22ca14673356390885e1432a95518a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ff9290599aa22fe6af8598a0f5d166fb87702394948213fbdf65b11f205759e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab9cebea827959c8d60062a13052f7d92aefb155de801253391ac1c7c98e84d"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe072630d4b910e88420d71241a7e893b3fe67a3aa94876fd4fd33f4e5b368e"
    sha256 cellar: :any_skip_relocation, monterey:       "78200b7cdfb61d088400c3d89c307d0ff68abbc4053bfbc975243a16ec6046ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50802c1fa306182a54399595e136a8cf9b41587e78c710c73b110c8f199c3689"
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
