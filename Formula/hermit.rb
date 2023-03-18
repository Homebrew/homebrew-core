class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "6bf08dcb3f4a0a71505237913a34c6f215e004b02f55a44ba7d26c9179baca54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5826a7811126eda4f04c3445e0c2a14babde0599711eb265ddb744c48468415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10163428735026f97784a9cb6051ad41f4cb1ff83d4c338893830eb62578deee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0621cc4f13c4890700b6886e15f642f34a8c4cb52de79e3a0c7e4a7d13dc28e5"
    sha256 cellar: :any_skip_relocation, ventura:        "4dec89235a9c9264d2b5ae342806eed02c37ba994eaf634dfbb13bb97235ec46"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e36afa0539e4101ce6e870c59982f2530e2d90bb2da4ecd78fa4b4fa0d215f"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb69c149bd14c083f6e46f1453e75da8977056198766568c71ecca462863ebd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5decb5ceb0cb1430b2383d387ca93c61176ae5fee0f7542dcc0ad12cd0f6a940"
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
