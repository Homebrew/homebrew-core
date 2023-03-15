class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "6bf08dcb3f4a0a71505237913a34c6f215e004b02f55a44ba7d26c9179baca54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce77c77fdd2e6aa62a53d2d98eac96d79bfab769a10410f3eeb07647c8b92821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a29f8fbd1b4caf7df392b3f66365fa6c5aa63f1965d90bf44e7eb09d2b45910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66e7e770cd5b03e29be3430622f7b5454ccb135da36e31651c088da16c85ed2a"
    sha256 cellar: :any_skip_relocation, ventura:        "64e51db1de245f8fbdb6524cffb699d0599947c3d20969c975e3307f45506dae"
    sha256 cellar: :any_skip_relocation, monterey:       "eef988c25dc1c0be645c92a9ba986c930d3466d176ff0a64bc8a70a7b89b3f3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "309447ec1344befd0fd3ccd251408122571f616e578af7dde318dbb90dacaa6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28eec77d5f2991f25a06786d9adf4af36d1197a80784124d18a8292a06c6c61c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hermit"
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
