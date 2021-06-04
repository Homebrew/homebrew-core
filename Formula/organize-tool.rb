class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/a8/f5/8a5c198b6640943b1ee1567751aa2be4473c19dec890fcd3457a4012676c/organize-tool-1.10.1.tar.gz"
  sha256 "c11dd3af2c03132226c218ad661176ef329575bfd324ad7576cd9ab23593cce5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e60ea32bf5482fe0c5ca74304ea5d9f1872abcdfa221de57be6a7ec99ab4cbd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "11a276d04ed01edebbd95ef2e0442efbaf5b41df2391314fe7f43cbe30dc9c91"
    sha256 cellar: :any_skip_relocation, catalina:      "10b35ad339c782773dc3f7b71919d39f03b9a045908ab65c34e7027ff18c4287"
    sha256 cellar: :any_skip_relocation, mojave:        "36160685dec476b6611bd3adda921654a5a08330682236f7773ce2492446c380"
  end

  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "ExifRead" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "mdfind-wrapper" do
    url "https://files.pythonhosted.org/packages/b0/37/156d27ce2ad1b54a67f25c0bc84425763fa6c447eeba5dba37141db5a8e7/mdfind-wrapper-0.1.4.tar.gz"
    sha256 "7b8f37e6e5037fea9722821f6d26c538abd1a08385a20820ab73158d70267653"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/13/2e/ea40de0304bb1dc4eb309de90aeec39871b9b7c4bd30f1a3cdcb3496f5c0/Send2Trash-1.5.0.tar.gz"
    sha256 "60001cc07d707fe247c94f74ca6ac0d3255aabcb930529690897ca2a39db28b2"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/1a/3d/4504e218fe50c988c8229fe4bfd5633ed43e1fa79de7147c5ddfec270fae/simplematch-1.3.tar.gz"
    sha256 "ed1d17d842799ee2222de1ea5f7fc3b4b1317464852214dc7dd197c1332a9f3c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/c1/74/1ff659d6deb1d2d6babb9483171edfa330264ae2cbf005035bb7a77b07d2/xattr-0.9.7.tar.gz"
    sha256 "b0bbca828e04ef2d484a6522ae7b3a7ccad5e43fa1c6f54d78e24bb870f49d44"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"config.yaml").write <<~EOS
      rules:
        - folders: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim --config-file=#{testpath}/config.yaml")
    system "#{bin}/organize", "run", "--config-file=#{testpath}/config.yaml"
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end
