class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client."
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/f6/2c/d3c4356cf1d6414b1b17bc2668a39896e07bf3e21364c2744751625ebf55/khard-0.11.1.tar.gz"
  sha256 "9fb5ef1947efe832974b54cab0ba2cf9f9bfb650297ece6b2b6b54cbb9ab7853"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e396cc9605c21ab5f16ba8cae16bedfc9429a3cac35d102df29e9e791d72d86" => :el_capitan
    sha256 "ef65ef172494f85ba5a042226081118fe3256c2a909b4c965bac7362ab84f512" => :yosemite
    sha256 "1be62406c146d9568e6738f3ca9421f8701719656c326bbe1705d9a265cb569c" => :mavericks
  end

  depends_on :python3

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/d2/07/937bcefd85b1e34c9eda82135a20cd9707b1b393c0aa6703f1d90af18a33/vobject-0.9.3.tar.gz"
    sha256 "10b150b87ee5fffefd3aa1ea12f31aab45a7b7d010d1ce6816afaff8db726520"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
    (etc/"khard").install "misc/khard/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<-EOS.undent
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match /Address book: default/, shell_output("#{bin}/khard list user", 0)
  end
end
