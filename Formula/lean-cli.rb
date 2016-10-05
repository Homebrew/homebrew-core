class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.3.0.tar.gz"
  sha256 "3efdb3ded13c18ef256f3fccf40ce3a04028f4af0c0e571798444a23fb9f713b"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b093985728e4af284ed2f1552f147b49585f400d10f050034b8edfa2438029" => :sierra
    sha256 "af5f07f4d4d9d0828ddb911f6031f7d40920ba570550b94899a84a42d7325748" => :el_capitan
    sha256 "9928b7b581025c84d0b7b8f7482b8634c96234d332af3b05acbee450e03ce9cc" => :yosemite
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
