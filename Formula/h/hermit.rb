class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "3c6be9238ee5c96e0447c1b1169e43a174551e3e70cf7eea4bbdc9c37421f7b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c7132de063325fd14c2b6dbc949ede0dfe61eb33e1705568bd1d223eff21445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463d284ec7c73526c7bf3a1353c8a0ac22c41d150695754f9095e4a493abcdb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57f652ac1399423c6b33333076716880cbc9ff9a8ccc2e318a518f6a5eb357d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e306c5ca5369aef55907242b1be574197b4c8326dd82d5f5f4f095bff8d19b7a"
    sha256 cellar: :any_skip_relocation, ventura:       "c3924c15a3e9462058a0cbf6dc2c174cc85f53e04f7652e6216494398aa52e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af8524950434281d0cdcb77684c56512c5f07074d5fb92e558a5248697f6234"
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
