class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "05e4a2addbcc6333266f2a8a5ba7e1707ad3e2586130b4f8a43fd402d5f76241"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ad7f32ad26ac36a7ef71473d62534f624ffe5aff87e87a3bb5484239c974bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58a19861e81fe1e1d09119c58e08d8020e6a32cf620bbcdb2dbcb2b516aa4e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6752dfc636ae8a8e770087d89b73f24c28975783d0657e835ef7de0a1e80bebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d64326b35f06aba6834e7a42d336170663f51fad8752b7235b17848450f13fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a1f27e9f5cbac24aa95de1f3ea7dbd5a1d4087dcf9eb12531a9cb1f71e3adb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1902682e16d1694ab34292e69c5d4f89df24687965c7cc7823268bf8ef5d500a"
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
