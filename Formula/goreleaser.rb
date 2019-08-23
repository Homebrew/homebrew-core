class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.116.0",
      :revision => "54b2d0de25be20032f8748d8378276fec545f2e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ffb4749db95719cfad5e852367b419e38db1761ad5e246cab0e7e84efcb882" => :mojave
    sha256 "9f51e78e69f69dac9069c7862f96c46fd6d02c1c7798add9cbd639f4efaeb8de" => :high_sierra
    sha256 "dda37d8ad35ce196fb67d5aadcde1b5c60c499ddaf2b736e03171cd2b3355fcc" => :sierra
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
