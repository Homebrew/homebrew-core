class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/lucc/khard"
  url "https://files.pythonhosted.org/packages/2a/b3/492568d98d71f034d069138848764d23ddbc393e78f8a4381405157d5917/khard-0.20.0.tar.gz"
  sha256 "178f32ccf01c050b5cd9e736282583de9a6445fd98e00388df792207629bbdd0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233a43b1af5d9cc99fb317e10ec0a1508276a1a64b81771d0035036298e9dd03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce93fc04d30ced8a224d1c44597a1446b5b65dab074dd3e19518775b437bbd89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8903230895d066074b7aee41a8e6de501184860cbf86ce5b1cc42acf9aedb40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d1e6b128ae04cf10d69d04a618f818d70486f5b4857e32eec69a920089596c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36da5861c3c4ef0f52dad66018508ddc509aa5ddb6072584f7b014fb7e7017a"
    sha256 cellar: :any_skip_relocation, ventura:       "2c5f36e56f7daac1e7e058d1279abe04a365bb049d19a9636a65d9c1ce5560ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c2da438d73230e52fb4e34e9ea6863edb218472054c93abe8ee58a382143d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378bca01eb81424251db35f4068ac17162141a9b23031d5762399dc1bc242506"
  end

  depends_on "python@3.13"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/47/06/c477d9a8b75471243f2b4eeef39cb639a1cf978990c11e9e56359ab01c82/vobject-0.9.8.tar.gz"
    sha256 "db00a7f4db49397155dd8a6871e8a2a0175a6eba5a654c30e910f82b29514b58"
  end

  def install
    virtualenv_install_with_resources

    (etc/"khard").install "doc/source/examples/khard.conf.example"
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
    assert_match "Address book: default", shell_output("#{bin}/khard list user")
  end
end
