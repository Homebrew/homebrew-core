class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.5.tar.gz"
  sha256 "cf5def9512ba8bda98a58a530688b1c9a730ee759ed50802bdc689608543888a"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2fa718b9b90ab184e43ff65d656ba9c03f1948a3932f0d5957b1e6c2d87753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d995e0401664765da51a4ae7d613fb167b56b9ed97dac0b9bd48b49205dd28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e075cb6aa76da1667a0c23a8bc79874d850b27ca3221504acfef832191ab56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bad02750adfdee33ee387908a64ece5de7876e3b9fe3a568c32a758f6baf866"
    sha256 cellar: :any_skip_relocation, ventura:       "a113371cfd14144bd52282a38b6f7894eb7882ab2f42d3cd05c1906ce11615a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cc2a406a9fe9ed1752eadaa40b8fa896725722ae4e0c30647246c61f26e084e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9232c72493ffe355ab76313d97654d9626f54a89048f8a6c12f8c2de5a3872"
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
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
