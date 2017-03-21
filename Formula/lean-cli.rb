class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.0.tar.gz"
  sha256 "0ae0fcaa671470e3ede04025e8f8dfe958a3cfdac25648dd36e74fed2aa0ffa8"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0a5d3bbd17b898f33e42032cdc5c0385795fc5e74e2a39cd6a785d3681e8391" => :sierra
    sha256 "f97458c59629527308ffb8933f700ab3c7973dfe15755a6e2625f39cdb549172" => :el_capitan
    sha256 "a0245be00163d4c1f2b9b4cf30120fce91a7bfdc12be8b29499f516298b91b31" => :yosemite
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
