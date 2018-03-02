class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.18.1.tar.gz"
  sha256 "804ab587dc9257db0379cc12043edec4ddced96f16967088e6d218afa7d46ff6"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e870f64217b3193ef5c6d9296a6ebc8f3d77b9f1b3b25a76e0acfd55a484ac03" => :high_sierra
    sha256 "c641783cded9deb3e48fd11246778300ad9121ec13aed425a1a1d6bf152a5af3" => :sierra
    sha256 "1f566ff288b68c627f1330a54c98f78c28b753c8a7f0a772f24b24bca157f6eb" => :el_capitan
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
