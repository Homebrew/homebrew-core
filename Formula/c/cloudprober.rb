class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "1b33653db6de2c2f07b2b4c552630b6ad9e21b49eeb0b07f73f1629d318bdd08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de0a01a6d52b6704fbb5670d7d8720f094ac0298f59ad3064fba8b7f513dc59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7ca5118127487e47385b8c903728e24e0bb7842565efdbb1b0be4c0e7e2e54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04584dec3bd9a4e356399329474e33d6fde3c3681da06ea795b1464ab24cd84f"
    sha256 cellar: :any_skip_relocation, ventura:        "2fcddc1e8300214f3a62d9a1cbe79a7f72c079730e8b392521d855f64316b2dc"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3d80c17fd3fa6b714a21acf318f29f107d8fad6e9e7328a236c1087db98c7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "67600bbd3259ca75a1e0178a8eaa953a0aef89fd375fbccda3392cdee9a9806e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29f78f623622f74384c125c0f2b47e67afe2c1db1b3ada0db5524e6f4d26cf0"
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
