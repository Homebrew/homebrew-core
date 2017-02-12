class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.6.1.tar.gz"
  sha256 "7dd0e9ffbf14b45744a51c8ad0d7c704e3ea0e78341cad13a6dcaaf175c1480c"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1822c4209f234d0e6876a05672bfeed9138b8cd83ba895da97a7c11873dc609" => :sierra
    sha256 "3df59a79a5012e027fdfc607e2998f73e6769dcafa22a67fec39dd2f366bb270" => :el_capitan
    sha256 "81421c18d44f5c95027eb74996573fe2a1266f521d65199331836cd5cb1c2ea4" => :yosemite
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
