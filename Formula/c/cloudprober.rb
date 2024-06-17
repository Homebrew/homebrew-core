class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "dd91e39beca55607a00876358174cfbc3f2249311942d2a04e9da3287c6c0c2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "962dbe3e9dcc12ee70d3bc542da2f4a55cc9121015ca558b74c2b26ab9e2c1a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9fff5fc3fcc1258f7bee93652bb3bed03643aa1da6c97d1416add0c665351d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d9d316671d306a431fcd97d990b9e800cc9091a40631cca94b990d2d1ddb9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5ad0c77348a6fa78317718cd1d748595cdeef29685d9341f58c0baffe7811ef"
    sha256 cellar: :any_skip_relocation, ventura:        "74d4dd11f90c2255a9fa362f03a1eda8cecc542d93344d7a507008db1ee4d31f"
    sha256 cellar: :any_skip_relocation, monterey:       "2880287ced255ef58473ea3a4b871655421340642cc899a7c96f72f0623fb0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fa69f74493f7b457d01aa6b82f673c698451ecadf8767edc32f10ac1dc5540"
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
