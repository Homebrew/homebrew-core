class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.77.1.tar.gz"
  sha256 "ee4788a44c1f5700188d1933d42f9637b682cce54333d3c5d267564d614f44c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "491229279c42fcc42fdc31d8c87694d30356bade307a4323b022ced5b294e561" => :high_sierra
    sha256 "1c76403d3f2352f550fa001ea9e772a428a52b4b9a924b74dcbd4e663ee4f3a1" => :sierra
    sha256 "62152fe1332831a991d0c21bb717a04fba804d73b877ae470ee5d0ad4eb941ae" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
