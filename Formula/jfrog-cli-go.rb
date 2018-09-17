class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.20.0.tar.gz"
  sha256 "c10deb6e730f81f6497d9f04bbec42fea720d812dcb090f9731a47af13e93b35"

  bottle do
    cellar :any_skip_relocation
    sha256 "5731a51bb8f9aaccffd0f400faf6ba71ed738e1feb0a318366c734bad2a42a16" => :mojave
    sha256 "df041833d2617381e554ed6dd97bf54d3a32f54ca7026897ef1b6092f1858727" => :high_sierra
    sha256 "039a0abc893d18b461c86dac366416389422cb6372150875e6eed8ffc857d4d0" => :sierra
    sha256 "62138b48330c1272806432465274b8ea97f5cbbc83eeb958b5b0fae8a45e612f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
