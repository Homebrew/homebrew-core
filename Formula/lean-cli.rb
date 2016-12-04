class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.5.4.tar.gz"
  sha256 "a2bd0b59b5bcc9cab56511683e77029f26bd4d49fe1c112b8a526d30a56c1324"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e71a76bc049322036de96698a95b13aa599d94dece1c307623bbeb4dd92bd24" => :sierra
    sha256 "f4c149c42e0f4e99ef038b309670a2f8fd00349cd264e06627444ed696645a3b" => :el_capitan
    sha256 "47f21c287b0652ce97634a17259c29941f1618af163d9f75ab0710d2b28c8aa1" => :yosemite
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
