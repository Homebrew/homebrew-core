class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.4.0.tar.gz"
  sha256 "d124541c928ad35681b82e8554c4ca56bea04518c648ad44a995f319db53cdb2"
  head "https://github.com/aptly-dev/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a745c910d6d3bf19602b8802c27699405aef1bce208430d0b3c7ac10847575c" => :mojave
    sha256 "d4d197b4b9269cea1f0f86d6e7711e2547931de3fff413ce12e2817f72c11e42" => :high_sierra
    sha256 "301a22114bd639602d1ec97fba77a06d7952e123532fe4a35a347ca026a93994" => :sierra
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
