class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.116.0",
      :revision => "54b2d0de25be20032f8748d8378276fec545f2e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2059bef51c74dbd2b8c5937709193a07bd659723748fce6abc74e2c9b755356c" => :mojave
    sha256 "aea32df452e47ef328d37100dfcd47440999a752da6cc8f6d91d9df9784e6cca" => :high_sierra
    sha256 "b9860deab8e6427b01a0fa035fd92d84b6bb5a0545b6e835a6162ad106fcc0ec" => :sierra
  end

  depends_on "go" => :build

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
