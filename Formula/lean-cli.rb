class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.9.0.tar.gz"
  sha256 "bc903544480330c67a546e054c1c84218264236337c1f32001ec5ea527638737"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "beb2dc50cfc7e0be59bf4ba159aa987e7bff3f498e505c067a8eef2001ef3a43" => :sierra
    sha256 "aebadf8b2f61d63e242daf9f3ad7c4ac489fa999480116c2d25a0429dad32c1a" => :el_capitan
    sha256 "e9371ffc2bdf2b22318a58351cc71493cf19773761d90547bc72fc3dcb317aea" => :yosemite
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
