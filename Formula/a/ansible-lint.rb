class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/25/6c/ad29634f856442a7cbb4894bf81eb8ae6ce256d86a1a2404537c3f1ddfe0/ansible-lint-24.2.1.tar.gz"
  sha256 "c3619deaadf852c353decff7242589bd1339e29271552e4e37bfa8f67db4c56b"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad2937d30c2db8ba57658473a06cd4e977c1648bde38a04eb38269aeed0e1c47"
    sha256 cellar: :any,                 arm64_ventura:  "bda3feb4bfbd4900da92a4a88f1b365f6f052a852936bf31224beeebc594b484"
    sha256 cellar: :any,                 arm64_monterey: "b5be5d6a30a785a363a5ec2b69e6f7ebfbd0362dfa5d4b131b088c68412398fa"
    sha256 cellar: :any,                 sonoma:         "c5784633fd5d3ecfb7385822f9502c447bbc2131f595541d844e6bad25ce377c"
    sha256 cellar: :any,                 ventura:        "9b395336f74953e747383e316fee3f227dc3357d11a42a9e5e83909d1d46f7bc"
    sha256 cellar: :any,                 monterey:       "81699ea4347f32b9615d96ca3374ffd550a9d18d1c01758823e143e0211c3f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe5d0fe268acd4f88286fb737f2f2ed4bd760e6c5f72b1f40b403248a60ab38"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "ansible"
  depends_on "black"
  depends_on "certifi"
  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/1d/fe/8751adb482109c8a6123669dc19bfc8462cc14a0fa3cabf4e740de3227ca/ansible-compat-4.1.11.tar.gz"
    sha256 "b3e9f9d7c3a1ce6222de444e9dc6fece7eba70ac64f2a0befdc4e2d542018b4a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/90/8b/34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633/bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
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
    url "https://files.pythonhosted.org/packages/f6/a0/acafd85c7c0aead293a16a70a49aba20ba2af9478771370b2897eae6059c/subprocess-tee-0.4.1.tar.gz"
    sha256 "b3c124993f8b88d1eb1c2fde0bc2069787eac720ba88771cba17e8c93324825d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/38/c6/0c5f324561c9396868d6badf571590c1a7802a81180c3097e4dfdc2f35c0/wcmatch-8.5.1.tar.gz"
    sha256 "c0088c7f6426cf6bf27e530e2b7b734031905f7e490475fd83c7c5008ab581b3"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    %w[ansible black yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
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
