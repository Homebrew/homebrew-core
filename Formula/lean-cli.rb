class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.5.4.tar.gz"
  sha256 "a2bd0b59b5bcc9cab56511683e77029f26bd4d49fe1c112b8a526d30a56c1324"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ac8936355abee460a12d1fb4e70a6ea93e8da249e60627a496d0e4d219d9e58" => :sierra
    sha256 "e05819e38dd56cb6637d368f21e71d976eb216aec6d6f6619af56e2a61ed25e9" => :el_capitan
    sha256 "e843a3f883d6e09743bfe3d42e124e76ef6f202041864a2fcb2f1e0f222e5325" => :yosemite
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
