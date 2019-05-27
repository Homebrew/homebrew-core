class Cheat < Formula
  include Language::Python::Virtualenv

  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.5.1.tar.gz"
  sha256 "9ae44cfc79478a7ba604871f3253e176f2bf3e1a4e698c9466e58a39d279effd"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "edc4911e3dc71c8307700c08aa1bd737146fc076842c250ad8d26de77c46d6dd" => :mojave
    sha256 "8fc5907164a0a1b4de27f7433e2908047dd743e8a34b9674f649e10db892c17c" => :high_sierra
    sha256 "1d585e8e457dec3245644177ce4b8716df1edca9a39fe958ebbb96be8917175b" => :sierra
  end

  depends_on "python"

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/91/29/3131bac2b484a9f87aed53d84328307b91fb238effa44ade3f241de36e4a/Pygments-2.4.1.tar.gz"
    sha256 "b437bc0d04dc36f1f5b3592985b3e0a3d0af46b7c39199231706d19a4ee63344"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"
  end

  test do
    system bin/"cheat", "tar"
  end
end
