class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.149.0",
      revision: "a69839327f0015ebb0990d41a6fa73b880de2873"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9747841e83433fa4a4ee1fd7a4b70160826b5f1c5166ae5047972f7706d5761e" => :big_sur
    sha256 "12bb77bf6b8aa8ee3fd9ef1d69cd4e45d1631f18e71fd9785a20df8e1b7a4e3a" => :catalina
    sha256 "d16b9c60c6db619b8e30d5d7b62ea306923fa1957ae4be9c0b58f4fe296129c8" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
