class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps."
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.14.0.tar.gz"
  sha256 "55c88685939f0b259a52f82e070303e2ffd69cc4b8117416bc400c2c079c9b1d"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37dd066fc1afc2415415df98cd801783f416d757fde4422f22c8bc07137e9d0e" => :sierra
    sha256 "da12b108ad31f60fb6a0170ede6268e794cab60810eae1359ecc374896bf1c56" => :el_capitan
    sha256 "a61ffa2ab7e74d6fe7aca219d52f9b599d646d4f8fbf251b02a5990baba629e6" => :yosemite
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
