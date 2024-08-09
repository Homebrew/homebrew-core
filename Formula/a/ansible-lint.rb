class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c2/44/8751d04184a2c4f3e60be27ef7a14f04257096303dcb8122167672d3cd6a/ansible_lint-24.7.0.tar.gz"
  sha256 "ca2edc7e4e80cf19df4b28cbf4c118f761ce6cdd6a5ef9c8561e454ed7af5a24"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20086459145de1cb78987f6df47d3d73939becc262c475a6475165c5311d889e"
    sha256 cellar: :any,                 arm64_ventura:  "360bdd6f1a4117ce6078fd969305236bdc40334856a4901993b342e202d5572c"
    sha256 cellar: :any,                 arm64_monterey: "47dfb782b877cf5d5499d91893d1a82327735ff0d964183fc081ce69f1a71fd3"
    sha256 cellar: :any,                 sonoma:         "577c65141717ae08515ba5705b9128e3f8f4f8d71f453d0560edd8c1fb847244"
    sha256 cellar: :any,                 ventura:        "78e8a02e0ac8af224f957e2a73ab5da05ff414e5c2507ccdb6fb66c960590e6b"
    sha256 cellar: :any,                 monterey:       "20b0e388c51dfac7365fba66e27ba78bd6b573d29dc6f4e04bd28a219f7e49d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25542c934e6e3123d165a69258a63ec2a3f709b2550ea5dad8050c59a5a8ba05"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "ansible" => :test
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/81/81/6ca881fa0afc1f9975feb96d08e48f048d0e6542ea66cc9f67f79a403607/ansible_compat-24.7.0.tar.gz"
    sha256 "7bc7a0c20a505a1eb6ff9877071fe20330130429087da298e25099a14f70d02f"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/69/9d/62cf1cb023710f9556d88c663950117014082387ddcf0fcc4c419a4bf0fb/ansible_core-2.17.2.tar.gz"
    sha256 "3dfa15249069ea0d001257902c968ddf9bb71d965769b8802bce85187556c5d8"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/a2/47/c9997eb470a7f48f7aaddd3d9a828244a2e4199569e38128715c48059ac1/black-24.4.2.tar.gz"
    sha256 "c872b53057f000085da66a19c55d68f6f8ddcac2642392ad3a355878406fbd4d"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/08/dd/49e06f09b6645156550fb9aee9cc1e59aba7efbc972d665a1bd6ae0435d4/filelock-3.15.4.tar.gz"
    sha256 "2207938cbc1844345cb01a5a95524dae30f0ce089eba5b00378295a17e3e90cb"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/20/ff/bd28f70283b9cca0cbf0c2a6082acbecd822d1962ae7b2a904861b9965f8/importlib_metadata-8.0.0.tar.gz"
    sha256 "188bd24e4c346d3f0a933f275c2fec67050326a856b9a359881d7c2a697e8812"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/36/a2/83c3e2024cefb9a83d832e8835f9db0737a7a2b04ddfdd241c650b703db0/rpds_py-0.19.0.tar.gz"
    sha256 "4fdc9afadbeb393b4bbbad75481e0ea78e4469f2e1d713a90811700830b553a9"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/ea/c4/55e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968/wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/da/06/d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63e/yamllint-1.35.1.tar.gz"
    sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ansible-lint --version")
    ansible_lint_core_version = output.match(/ansible-core:([\d.]+)/)[1]

    ansible = Formula["ansible"].opt_bin/"ansible"
    assert_match "[core #{ansible_lint_core_version}]", shell_output("#{ansible} --version")

    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - name: Homebrew test
        hosts: all
        gather_facts: false
        tasks:
          - name: Ping
            ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
