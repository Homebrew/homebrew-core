class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.6.0.tar.gz"
  sha256 "94d5e90ab9c9992ea0bc2491646141d86070f2f6cea251308b08315ebd6acc19"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 "f6cc6aac4dcd67b5a1fbaad3086536b7236cf71d4d31e3a9f0925443dc683387" => :sierra
    sha256 "3e13d01871000ec5f59d9f04c3c1124857b717de56baf96bea1f157f3af75687" => :el_capitan
    sha256 "8c2e74e0c6fb357e5f1714592a328f1130bca52a0b610d307236b3f5289abec3" => :yosemite
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
