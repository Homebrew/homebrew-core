class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "dadaee7a84634c55087fbf6bf0d2de1838aa89ce31125eafbb0b5779757583f9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dac5137cfcd0bcce589cb545b773578ffc80a463f3e3583b2067176e4709a06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10b9bdad1f60c409382076623452598cdd78a74aca0c8730a73017e615ce2889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b90fcb5fdd851b6343daaccf3e70bfc5d17e0a6286c73bb0a9ebf46ee96871"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fff9b3eb6c37d38e7dac30a5845b4dbe31ebfecec201a8136e82b364c21c8505"
    sha256 cellar: :any_skip_relocation, sonoma:        "6340b6f017c995c72b72924dc0744e4ea787c517b4f944c80883c26d1ce3f76c"
    sha256 cellar: :any_skip_relocation, ventura:       "dc2dbaf0b6e87774aa069b10fe6714a7f5f8a2d54c11248c585afa8c8dbfd450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8cfbf2adeb50c1950bc699a38810b5d6f7cc9e6c4dc76dbf65eb9fbd7da249a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df76cbe5172a33ea40688700ffc719af53244bb94043cb83f62bfd05fcfb5405"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pivit"
  end

  test do
    output = shell_output("#{bin}/pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end
