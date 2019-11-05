class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.7",
      :revision => "25f9742878f47d5184a806fcaafc46ce82b7f705"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f6cfde1d919ca9b6968da2ed3cb34c439bb811591d4295f0f1d4c0886e0fb7a" => :catalina
    sha256 "7f254a05087d43b2a6e753c87a182dff8ed866e37991e1e6b2aadf006f4ef1c2" => :mojave
    sha256 "511c8a71b601f15c1d9d4d54c6f8ee1992d081e4dd2f300a40ced44ec1813e78" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/goreleaser/goreleaser"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags",
                   "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
