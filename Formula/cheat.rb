class Cheat < Formula
  include Language::Python::Virtualenv

  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.3.1.tar.gz"
  sha256 "f944612b1d1b97dbe87c6cc3c68932df983482f53a09b0446c318ee7399c865c"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af8476b088ecb10a559b4082bcbee85e30c243b1bca56860a2954e33cd4cbfd0" => :catalina
    sha256 "edc4911e3dc71c8307700c08aa1bd737146fc076842c250ad8d26de77c46d6dd" => :mojave
    sha256 "8fc5907164a0a1b4de27f7433e2908047dd743e8a34b9674f649e10db892c17c" => :high_sierra
    sha256 "1d585e8e457dec3245644177ce4b8716df1edca9a39fe958ebbb96be8917175b" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
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
