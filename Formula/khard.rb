class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/38/41/e54a6ef446701a4ba723df8850189f62e9e9a320de9ff2b1accadd589cc6/khard-0.15.1.tar.gz"
  sha256 "5ca8e678133e08fa4861cc31aedf9f30b4f8e3958ed66ede025c23ec5e176aa1"
  revision 2

  bottle do
    cellar :any
    sha256 "e52491d70166c2919a0ddf1d31cdb29c68aa66950e2b6b0338ea168b7b85cad8" => :catalina
    sha256 "ddf64becc35493212418f1855bfdcad659b1fe3e541f4a2dca49528afe3c8a67" => :mojave
    sha256 "9978c59849d3f400b89596318010908b9d5d41970d0b9870afa556d6157dde81" => :high_sierra
  end

  depends_on "python@3.8"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/ec/0f/cd484ac8820fed363b374af30049adc8fd13065720fd4f4c6be8a2309da7/atomicwrites-1.3.0.tar.gz"
    sha256 "75a9445bac02d8d058d5e1fe689654ba5a6556a1dfd8ce6ec55a0ed79866cfa6"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/de/76/cf97d739365eff258e2af0457a150bf2818f3eaa460328610eafeed0894a/ruamel.yaml-0.16.5.tar.gz"
    sha256 "412a6f5cfdc0525dee6a27c08f5415c7fd832a7afcb7a0ed7319628aed23d408"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/da/ce/27c48c0e39cc69ffe7f6e3751734f6073539bf18a0cfe564e973a3709a52/vobject-0.9.6.1.tar.gz"
    sha256 "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101"
  end

  def install
    virtualenv_install_with_resources
    (etc/"khard").install "misc/khard/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<~EOS
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
    (testpath/".contacts/dummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match /Address book: default/, shell_output("#{bin}/khard list user")
  end
end
