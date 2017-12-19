class Cheat < Formula
  include Language::Python::Virtualenv

  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.2.3.tar.gz"
  sha256 "adedab2d8047b129e07d67205f5470c120dbf05785f2786520226c412508d9ee"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5eb69f05c29b9be7a0b453d5dff25abf91af51c5a5c4c5a3956b78955bd0be6c" => :high_sierra
    sha256 "65a2bf9dc7f1c50718f9811ad89958409ec14a24c140332a468d8b6520989328" => :sierra
    sha256 "5da06a7464f2ef810c33d96f075dad2b5d5245e5d8e7700903d89daa029ca46a" => :el_capitan
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
