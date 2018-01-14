class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/f5/0a/2ac16043a7a970f33306a4501948bb7dc02263d82d12e67e7578cb938bdf/khard-0.12.1.tar.gz"
  sha256 "230cff736a6ec2bbe9f4456fad69e586fc88e64f1bc7245b753e68976829fff6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a03d8d18a03b4bb3c0b4f3d731cc2fece1ee63bc1d57669b1e4ed259501b4773" => :high_sierra
    sha256 "704cf1034b3aaa2ef9e3723e43b50f941e3acabee40804fa17c7d2c8c0e5fbbc" => :sierra
    sha256 "4986a2a94a089fe0e13344ad61192f9e55bcb84cfb7d1518b08df53641945c31" => :el_capitan
  end

  depends_on "python3"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/8f/39/77c555d68d317457a10a30f4a92ae4a315a4ee0e05e9af7c0ac5c301df10/ruamel.yaml-0.15.35.tar.gz"
    sha256 "8dc74821e4bb6b21fb1ab35964e159391d99ee44981d07d57bf96e2395f3ef75"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/8d/8b/2c6107d0132fd2309ee870eaee8501808e4e9d950e729a3dfcbd9dfd5b81/vobject-0.9.5.tar.gz"
    sha256 "0f56cae196303d875682b9648b4bb43ffc769d2f0f800958e0a506af867b1243"
  end

  def install
    virtualenv_create(libexec, "python3")
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
    assert_match /Address book: default/, shell_output("#{bin}/khard list user", 0)
  end
end
