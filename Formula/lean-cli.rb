class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.9.0.tar.gz"
  sha256 "bc903544480330c67a546e054c1c84218264236337c1f32001ec5ea527638737"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f89556362e0f86ae979af882eabebde1b5cc8b97b7fd139b69e4dc4c71b9ea8d" => :sierra
    sha256 "e76288299ccbdd9acddc66db5544213a41ddd6067c2cf9c201d8b951056b84c5" => :el_capitan
    sha256 "e23bd3d423b71c94600fd5a6f12879125c3748acda31be0d308e045ced40aee9" => :yosemite
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
