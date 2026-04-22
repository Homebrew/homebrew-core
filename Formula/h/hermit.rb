class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "2880db13df84630ddfc76e616d9ca1993d02e0d410f76c784944954494b6ef9d"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086e4e40a9f279053a9b842a9c087d833164d57281304f7a513a44cf5db2402c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dff8ee22bd32b8275fe3a74f6aca00ab8929ac705f8541bc275e55c3d20bdb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1879c86f918eea0b74d1d50d3045e3f02aad809f957e5a7a35a41623d47f336e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a16633fad5996c5794eef5594a38177661e84667f80a479c6820890cf69247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5ee2861852cfec51994380dfe03a6d49bd1da5aa83347b92e558d77eb45832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7872f281aa49f7bab33cada17b489514677d79ef4329909ad0fb340e4febee57"
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
