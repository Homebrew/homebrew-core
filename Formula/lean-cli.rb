class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.1.tar.gz"
  sha256 "a46f45b22d54790a2ad6a4cb46d968c7227e2759e3de7b7d8d2bf0aa86081d4c"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea8dbd322490c17b864e7e39702ae4af1f38624ccaeb2a96fbc881167d15c35f" => :sierra
    sha256 "84a8f191a997e23064deda0b8098518c5c6c526ca89c670e51cb1f7dd4619f61" => :el_capitan
    sha256 "dbac982152a9e7ddd4ef27594fc8d44834e1f37db101462d73a0e37e0c5b6a07" => :yosemite
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
