class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "b02675024c70e3eff17e617abaf039a81fa904b3766e8c088ff96e2aa5eb9adc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9117ba72ca19673ac263da9ec4fd441d265c323460035c2c403126b180a3313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c220df0abaddd3cb46062522fec8b741a9cf53aba2f1a81415d83f2348d530b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681669b16e6c7a1c781239e55d2c20212f96ea6391062bb50b96f5891fa9ed4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e50c49956f01417343085c1e9cf05ccd0884f946e723b86a1f6e908e7461963"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c924c2ce9dd1494f1a337269afe564a979f899e818cac2ce54b49fba7130aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "8f22be3a87fcc32e7844683ceb514af7ec0f63b0b69267140d94e2b3f2afaeee"
    sha256 cellar: :any_skip_relocation, monterey:       "0d44943a092f4a2cd053848d6ce7f9658b5c4b9bde5bddd8ccc978cad324051d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75ae195b938d6ad57589348f5522f7b8b07687a2b767ecfefad7c636c8a7db5"
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
