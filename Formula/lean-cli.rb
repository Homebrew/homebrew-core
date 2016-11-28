class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.5.2.tar.gz"
  sha256 "65c4208b9fbbba8f106157dcfcd9ff1694b1c87e540026f0bb8246245ae3c656"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dbb1ebfe9d2cd608982caba859299c8958ae7b20396752c69c1dd3e8108e78b" => :sierra
    sha256 "967fe018d8b1c1a4c2194205397c7ad6a34b82336b08aa8a1418509a3a615747" => :el_capitan
    sha256 "c6181f20cc1ab0c90db8b037a85faff48081d585fcc7bba032695b585046b219" => :yosemite
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
