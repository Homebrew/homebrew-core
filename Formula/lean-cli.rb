class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.16.0.tar.gz"
  sha256 "52ce56d827d242c9a1c41666ae0dde26dcd47dfb6ca590807816180e24eed135"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf3832aae8aeafe5972c965b842ec7c1cb8e79f11e028b98be385160c98317bf" => :high_sierra
    sha256 "6f9e1e131b123d9f9bda7e4337dc2dc35ec321c18dcfb63e4b0638394fa87111" => :sierra
    sha256 "307b90b2cb869e48493cfe9b6cfa449b4dd8ed0da50ca048562c76cff6dea312" => :el_capitan
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
    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
