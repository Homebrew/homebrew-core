class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.12.tar.gz"
  sha256 "cdafd383d866dca4bc96be002d5d25eeea4801d003456a0215e28a2fba5a0820"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6f79c60ab990d249f47af44310ecb93840c8af784aca73aeb413fdbd24b58ea" => :catalina
    sha256 "832b5e24b5310320c075c083e149ea59d59f1b5916bfb3d47093053a26930491" => :mojave
    sha256 "fdbe96b882426e313866bedb826b606842a9448ad9884e23b171bc97f2205803" => :high_sierra
    sha256 "983714f0e0e358b0fed5f300214cfdd8404edd6817b0f5bb0fc756cb61cb4bf4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/exercism/cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
