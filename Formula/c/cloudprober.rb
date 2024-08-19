class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "a937a95b24d07e3e1fb0e2ab0c0d457cfdfd799206f9c3f6457ff8f029d03853"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "332dde7dcedca3ada7572dd9f7db52397efd7ba96d4f97bb3ac94b7ba447e570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee213123319f20b616f2a5e7865cb303d664db917bc094ca896ade71c237267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc365055e984dc35cef08cf40fe2288afa3c35f8d89d26cd5496e0c192b4048"
    sha256 cellar: :any_skip_relocation, sonoma:         "0289aab1009440f30c84cd9f3fc4129ee676cc39fa2915350a77fc008840b241"
    sha256 cellar: :any_skip_relocation, ventura:        "8f9a1ca4043796da1fdcf6b4d617670af97429c820a601258c4e9d7df0813bce"
    sha256 cellar: :any_skip_relocation, monterey:       "091ef1be0980ed30b6b0b5b2559312a0144e30cfd8e4d2f1631e3b5c077fc745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63dda14025f482dc90282d79daa00ae4883c4596c763e0486dd7bc8c290ce339"
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
