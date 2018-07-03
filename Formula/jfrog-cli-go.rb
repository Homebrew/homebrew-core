class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.17.0.tar.gz"
  sha256 "660480576026c5ab9e9f0d392f747b096e2d1141b4aeeeb088091cffa7ee336a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f50b0d36a0095878e1c9c1297a5514c43c245f20b8241dc57b88a1fba491b8b" => :high_sierra
    sha256 "1bdae986d972581d95ab3e3650a62ddce2114c0c0b10505a977cf412579be61b" => :sierra
    sha256 "90d40f74b2f51a2528ee5b632c0ddae7775978941e0740e7f11dba97823cc0c1" => :el_capitan
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
