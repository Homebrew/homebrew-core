class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.118.2",
      :revision => "d1e97a3fd8bc8e0680329a5f45172c9788b6f057"

  bottle do
    cellar :any_skip_relocation
    sha256 "839280137bcdcc14f29c892c01e7c465ccc36fe62b905e435bab008942260210" => :catalina
    sha256 "8ef334862e473c30a273acc7eb552ec438bdfa126156032bbe85ac93b4c3ce8c" => :mojave
    sha256 "28177e58ab866d7440b6c65b67485f6c1a21f9bf75cbf66e83476daf7f207e85" => :high_sierra
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
