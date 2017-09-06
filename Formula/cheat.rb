class Cheat < Formula
  include Language::Python::Virtualenv

  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/v2.2.1.tar.gz"
  sha256 "04439b85ea2ebdc6d041352fb8b7aeb8768f2e4df68280371bee313f759f3a50"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "671a39b92371c3bdfa79f3a3cd17395c23362b1b5c06297363a53ffe56ced9a0" => :sierra
    sha256 "46be2714a5ed03794e45b7c89b439b1adc34f3ba0949167e1f835b17e5d73736" => :el_capitan
    sha256 "687ef459bad701073c784ddbd5ee9864e422d5910a37702b479dba643a387b5e" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
