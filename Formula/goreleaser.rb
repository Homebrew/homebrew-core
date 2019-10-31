class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.4",
      :revision => "576156b03c9429fc66ded230ae34a8c2ac2c28ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c7ef1fe5bdd0a46c2a03bb43beda209f596fd7c7263aa7be32a159002a03cd2" => :catalina
    sha256 "7c1dad264d165ed08bd0efda0a1ca1cc896cf5073e72e1ee9fb279a98a49bd37" => :mojave
    sha256 "892327f6d77e0c65dfbd9d8879ba8976f77617838bff7b2352a3270fe946ca8d" => :high_sierra
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
