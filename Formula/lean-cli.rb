class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.2.0.tar.gz"
  sha256 "980980c764486aa933255fd64d391560e72bba78af8427253e1b4515ab6b68eb"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c42d68d8a3602a3a8c480de370a3c653e30a0d0d2d017995c06e5997e4fd27" => :el_capitan
    sha256 "1edfacc141044349ff7aaa51b2c148d2c12964f650dd73060e796bcce9bdc315" => :yosemite
    sha256 "be1b7966c0b0621d65bbf22035c8f13a9c0adfbf9ff67e89ab255d0d7b701d79" => :mavericks
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
