class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.4.1.tar.gz"
  sha256 "9274be5d52b2e8eea6b8a8a5de90e6e6ecd9c0f2aa6562003809ed99bb2a251b"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df4743e06db3ccb7b1aea71d39936a48af3ab7db4315d6d0bc26b12c33ea94d6" => :sierra
    sha256 "8fde0e1b89d9cc5d891600a5f828ea63a6c66d3defc0624c6f2d7f13899bcff8" => :el_capitan
    sha256 "251a73ab8682b3eac5cc3a18052410ea529d55a1e0c98b495a4bd1501930128b" => :yosemite
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
