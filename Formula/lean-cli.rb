class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.3.tar.gz"
  sha256 "cdd5f1d359198b324f665c378b4e94dcc9efc3393c287ebcf1934549c070411c"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e4bb7966b4205ed8265179eeed8e50684f6a223544d018695ff70e57c16ea37" => :sierra
    sha256 "d2aa11bf172a36122ac07bd74506ab3143eedd77c3ed0500e90383cf8ee887b3" => :el_capitan
    sha256 "f548c2c3a663a83b6835fadef71e3c68b910e2c13d497557bd256f46fd1050a8" => :yosemite
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
