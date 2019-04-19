class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/75/17/5b97ce7dd15e835e801f513dd80fb4fee8c6f45f5c5be7c3a2b8b839121a/khard-0.13.0.tar.gz"
  sha256 "fc93d0b91f7e688a8f60896b4ff7b1968d6b4cb58d80fca9977232c3a68ed2d3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3e0a13e917c8e8b9f6bae079b5d6b95d39886c9ca12e01564b853dd25af9c21" => :mojave
    sha256 "1162f54e63301517898aa57f2662a862e187b3ea2eed50969c920f2b5109c14f" => :high_sierra
    sha256 "9e52f82a2c6189e6d6d0d6f47a725c6ea87beef2054338ff0e1dcf9a4facd0a8" => :sierra
    sha256 "61c299501d8c6395fe825e7858835a35281019e6d35710715e73ee616d6d056b" => :el_capitan
  end

  depends_on "python"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/ec/0f/cd484ac8820fed363b374af30049adc8fd13065720fd4f4c6be8a2309da7/atomicwrites-1.3.0.tar.gz"
    sha256 "75a9445bac02d8d058d5e1fe689654ba5a6556a1dfd8ce6ec55a0ed79866cfa6"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9f/2c/9417b5c774792634834e730932745bc09a7d36754ca00acf1ccd1ac2594d/PyYAML-5.1.tar.gz"
    sha256 "436bc774ecf7c103814098159fbb84c2715d25980175292c648f2da143909f95"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/88/df/4f095aa617391f789a8df22d3b44fbaf7274dd90dc4982b2fb0637a0fbbc/ruamel.yaml-0.15.92.tar.gz"
    sha256 "c6d05e38a141922eca7902135e7a40b605763d6da8ec6624517370631ce9fb6d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9b/d8/c1b658ed7ff6e63a745eda483d7d917eb63a79c59fcb422469b85ff47e94/Unidecode-1.0.23.tar.gz"
    sha256 "8b85354be8fd0c0e10adbf0675f6dc2310e56fda43fa8fe049123b6c475e52fb"
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
