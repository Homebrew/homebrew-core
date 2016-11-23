class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.5.1.tar.gz"
  sha256 "20b7d8bff0505115c6d19b5ad4398f5fb40cf607a0085f97028163abb8f991aa"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfec765a29d284bd6276cce4a860d8ca7670960e405aaf374e618446e2a88a78" => :sierra
    sha256 "cb65e97eb74eae90faa6f3d662e1f22a1fb280e7d807512764f1cfac68aab619" => :el_capitan
    sha256 "c586f5570ec94ee77fce9c977c4b9f87d511057b1e7dfa6783c8f5bc95b7f311" => :yosemite
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
