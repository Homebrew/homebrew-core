class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.4.0.tar.gz"
  sha256 "4172d54613139f6c34d5a17396adc9675d7ed002e517db8381731d105351fbe5"
  license "MIT"
  revision 1
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4b9b701d448d055a16c970ab0aa4af3d15c9ab0d9f60df6d380ad186956284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e20f2357e98719f0364e6e66322d0ea2d59b8be278cc656ace3f6386212fa11"
    sha256 cellar: :any_skip_relocation, monterey:       "ea06977233174e186c5b5e77019881772ca2cfc323d25557255c3a3ce2c955d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ddf3032efd340ae06b8038917c4493facd1e4e9a64244b092d2d00f0904ae1d"
    sha256 cellar: :any_skip_relocation, catalina:       "d14f3a2e0589a69b545078f4408a7ff804f727769f9ac0f66b0e08cbed96a7de"
    sha256 cellar: :any_skip_relocation, mojave:         "4a164a193db58e11d6e7b18f7e911a8d7a96e8b40201160b822d8ade95181f65"
    sha256 cellar: :any_skip_relocation, high_sierra:    "53301cc0bf47b4eeadf784856ee71bc72c9be5db62ad0462ded0f843aed49b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6412f542bf6952762d6e04f702544ff88056eb33751ba6772735356bede2203a"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/aptly-dev/aptly").install buildpath.children
    cd "src/github.com/aptly-dev/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
      bash_completion.install "completion.d/aptly"
      zsh_completion.install "completion.d/_aptly"
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
