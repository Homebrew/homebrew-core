class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "0464359d3b388b59b0d43653f2722da42a75579a04007769f9379e96810948c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "756471539e992dfb5e3f0b70931dd7a22b38c76bbcae506f71334e464a9fb9f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64b4185497d154d16c6d97dbe114f7bab43afd6841c4ad090f8e2ab56fc59ef6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bf4157850af41211153e9511e99bc3cc6bda1bdf231514be30ec2f32743d84b"
    sha256 cellar: :any_skip_relocation, ventura:        "14cd25278fac6411856eed0c7be84df87cc298f1225da48b2eb3e226ebf5c0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "be485fa8214ef472f12c1a0499e2f1f8ebcd5986751bef44a9775fa9a5394e3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc3ec34a625ab7cf84886f1281ef454019f8bebba787d7c17d5af79505dddff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e4da07bb55ff71a322841ebac7147bbcc8453876957198a23b6d07dca24de2d"
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
