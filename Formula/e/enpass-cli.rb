class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "0665056659ac31444920f0fed522aa72effb3a090365f8a854e44c35ae97f4db"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd37fa833f723fc772f4ead4b62d641c83ffc0bd549fa983420fa934136a6a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42fb434b400316d1b30d8afd177f508b946c37d63bdae47e6723ba1e8a38118e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9386875aaa9f35ff68e804199e01af953513104f6e98a4c10908824fb1f80507"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9825904c9285b2d0632d4abb734383d201a0c6ba8e1fc953d8b69d8685a2dbf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5686c028c3799715775908fad8cc0100bfe00b934f65ca76b3de649f05ca3726"
    sha256 cellar: :any_skip_relocation, ventura:       "30be7ad0993505758b4d364890a41bea9398e17f8dec313dc4a46ba1b9cb955b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f24335185c0da29b2ed166a4b5ac652a0c35786f38cea13c962d3c44f213daf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7d55eb3ea4ffb7613bf4d5f71da4d684bcad8b98d783aa9b173bff7acbe8ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"), "./cmd/enpasscli"
    pkgshare.install "test/vault.json", "test/vault.enpassdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enpass-cli version 2>&1")

    # Get test vault files
    mkdir "testvault"
    cp [pkgshare/"vault.json", pkgshare/"vault.enpassdb"], "testvault"
    # Master password for test vault
    ENV["MASTERPW"]="mymasterpassword"
    # Retrieve password for "myusername" from test vault
    assert_match "mypassword", shell_output("#{bin}/enpass-cli -vault testvault/ pass myusername")
  end
end
