class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "dd5f2fed9c52a154c209dd10de5e9eba077b2ea53c9e15d641d0f5ebec9c0a49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2008fdadc7b2b01ab5b91ede9f247efc03ea63a882be7dcd4d694b1ce5e8ef9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34fc95c1c470462dcd4ba5abddff177aa104e66be940cb21383c6348d383ddc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39a54bb7992da8d007a365e7fbaef65a5bda0c4ed942619e714bbb0669b420c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d68ca656d147cc40408114e5fab16871e2081856ea53f4d0bd3c332d6981f98"
    sha256 cellar: :any_skip_relocation, monterey:       "ebc6e76278ff0f537f17083748427282557523edf1f014dc6e7cf012de249d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2234e82df30fbb9e1713746f72e7b37a0d1e560e04989d35f03272970fcd285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592ad4751b148eed30a5b9265fc23db6006c425adc900b1445454f6ab810c3cc"
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
