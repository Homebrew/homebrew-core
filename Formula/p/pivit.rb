class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "dadaee7a84634c55087fbf6bf0d2de1838aa89ce31125eafbb0b5779757583f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8905b125a058d154f33ba2c1315dbe971e988bb858a103c0266637fa49f05a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab13cc17269b075c1d300cc957f21df8257fddf9e23404f88cb9ec3bc3ff22e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a169ca42100f3fef700fae42d5e3eb74398c7ae474d90de841fcadee768d8cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0571959de174a34bb941d952b67f0026f071482842ce26ce3e3cf227213374ff"
    sha256 cellar: :any_skip_relocation, ventura:       "1692ff7fce8b4d423a874a6aafc9b0e8e1628f54b357b850140d74d09917abb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbef3ead98b26fa4a6459ff2eaa71c77e46c3d4989890a5ca7104dc89c0ac04"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args, "./cmd/pivit"
  end

  test do
    output = shell_output("#{bin}/pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end
