class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "332e6c68cf007e2d8b7d36f20f81480cf3846f8b398c97afdcbc033c8794a2a2"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46096a2c51f49716dc8c1a1daec8974a5c99b75c641e7fa777d696ddd10c019a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96f8fe2b7d757a7702779658e9fed166a2d713c680e4856073a079dff03a7dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5de765c5e288a798a494c96e5d867cccfba6fbcc00c7497fa2781055b2c696e"
    sha256 cellar: :any_skip_relocation, sonoma:        "820b6cc5d4db79a33cee6eb2ae21f17dae2280a70e19f0f92d5d75ca08c6d003"
    sha256 cellar: :any_skip_relocation, ventura:       "f411a7bf8fb63032aaa7326184b9656dea5b618407a4d986848d0744c356d26e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8fb1446b3138b9b3e4d476c37b833baf1a09246b34554d275262fe02983c294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d96d68e2739e4bcfb1d7ae807e39f250cec137528fcb6d6df661aeda2a62629"
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
