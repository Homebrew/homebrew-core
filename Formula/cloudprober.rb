class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "0464359d3b388b59b0d43653f2722da42a75579a04007769f9379e96810948c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed574c5802414eff22f60f44110697ae3196f73add06a8a7e1b759fc84614e87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ff0f12c676cc0106467d53008f80f7fbd3459b5ef72fdb0c2cc8afefbed2a79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65cfd91a2e79eaa3d28f096daeb362e868f471a555c0003f5e7162837043881e"
    sha256 cellar: :any_skip_relocation, ventura:        "ee1151215192715e77956be4488966ad0269b0a4f90c59724d771c5ab4823cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a7a079a95402ec61d097ad2760582e707d8f739a2ad847256625b23c05f731"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce84097d8974c3b06f3514c4a4202f10caa4bb54db40bf84335aff6806499f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8f3ab2240841449d26d99fe791cf83eb434128b93c6913a3b33fe3ffc4ecef"
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
