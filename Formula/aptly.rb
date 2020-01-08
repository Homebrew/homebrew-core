class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.4.0.tar.gz"
  sha256 "4172d54613139f6c34d5a17396adc9675d7ed002e517db8381731d105351fbe5"
  revision 1
  head "https://github.com/aptly-dev/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d14f3a2e0589a69b545078f4408a7ff804f727769f9ac0f66b0e08cbed96a7de" => :catalina
    sha256 "4a164a193db58e11d6e7b18f7e911a8d7a96e8b40201160b822d8ade95181f65" => :mojave
    sha256 "53301cc0bf47b4eeadf784856ee71bc72c9be5db62ad0462ded0f843aed49b42" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
