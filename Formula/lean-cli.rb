class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.7.4.tar.gz"
  sha256 "a365ea43b003b10b21cd91a651318e5be1abb5f5ace6886684f1753913263ffe"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97224f89de293146b2d85a75f901dd7cb731a07907f29762a1702aa6de9c5d3e" => :sierra
    sha256 "3388e699dfc9f61e2a5240f65014922ecf0c7a7afad4cc51f416724ea60da6d6" => :el_capitan
    sha256 "b8a07390feabe9ec79df979281a7176a1e8f93540de1ae8e519c336ad61ef574" => :yosemite
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
