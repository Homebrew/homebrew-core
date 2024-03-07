class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "c88afe916f8a15c3fe200746ef60253cb94dc962e4809d3df86e932867082aa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dba559ed140842cb282d2050d9ea40e91bdeb74da6bbcd6f184d25c5ece53960"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "965e7d18a46a95840cdf47d503213ddc3be67a6a04b0ed624f20d4ac917c361d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a8f5e3e94e36989fac777fd70fcdcc9dc613b9f8f6b00028fb5b1fc7f79462"
    sha256 cellar: :any_skip_relocation, sonoma:         "36ed70e642f74d889805f33d7378671d1043bb071cf01e30b083802021718440"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1279b2da6f486ff74f8accccdec0d7f01fbe429293001df9c4835183620fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "050d6eee21bfc534c34866089799c732bfd410de0c6f2641450c76c048963b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10db53cbcb94d090adf4cd160d43b0ba06a5e7772c4b03e70fcac8d790c01b1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
