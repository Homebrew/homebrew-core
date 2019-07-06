class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.4.0.tar.gz"
  sha256 "d124541c928ad35681b82e8554c4ca56bea04518c648ad44a995f319db53cdb2"
  head "https://github.com/aptly-dev/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19b910566b07b2795bbc67ad1c3894c309cf772045922baff0dcc5e3f53329a8" => :mojave
    sha256 "966f18f15eaf50533ff84926ed2d1a302b9da5dfc860b65fc94f89efa06622c8" => :high_sierra
    sha256 "c3137ebf033719c6076b2fdda72d01bb91fd286affe1535ef84c8d9f388ac414" => :sierra
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
