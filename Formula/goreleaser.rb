class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.117.2",
      :revision => "2c08ab87a13ce4a70cf89a691fbbc46c7da6c2e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e10336aea2dddb3ee0fc4b602cac2b08aeed29015a28b94f381b22017cc66bf1" => :mojave
    sha256 "51acd8378f68914c2cf92f2e8db7e4357024b69f4ad1efec5edfe367bdc9cfe1" => :high_sierra
    sha256 "188cf53e7074a0efaf73c88b0af27e966cd44ff459fab3a2da27cdfe3e8054b9" => :sierra
  end

  depends_on "go@1.12" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
