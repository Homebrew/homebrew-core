class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/f1/f0/6c702268d809b3b07f5f3ea4ee08905c5c8fd92fb5a868cffed4478ab8b4/ansible-lint-6.8.3.tar.gz"
  sha256 "2faad6121d5c4bd239f6964e06742514f0bb079687cc24bffb76c73952e6ebf8"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d88d9aadc9f27ca2447a9cec81a2eeaebdf0b3ab6b654f5bfa54499e095f190a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3436cb63dce13fd352a5abe98327e866e13697ff60b1dd4abe33ee31224dce1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "992d18a08111aedd43df425b0a6e4343f6c088019974f1226261375303de3822"
    sha256 cellar: :any_skip_relocation, monterey:       "648023d8411def985e03fc64360b852c46a070001346630d492b4ee6cade8701"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0d8f480101a33ebdc88a719eb582c9dea50b881e0b1f21cdb8b6b6e2c76cacd"
    sha256 cellar: :any_skip_relocation, catalina:       "7a6e2318dca887236587e724ad2886a3c452a84e7375e045689735bed1207a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b84b222f63812a24b8e1a72fe535e85d70e44e210a82f0f0058337e87a9218"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "jsonschema"
  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/e7/20/3cbc78afd3bee6a30b95506819b57e70e4e12c3c69da4de35ce2dd03a216/ansible-compat-2.2.1.tar.gz"
    sha256 "7a012753a0a02dab2f22b0e574e3e7b00399f660606154474ffe25621fa80d3b"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/a3/89/629fca2eea0899c06befaa58dc0f49d56807d454202bb2e54bd0d98c77f3/black-22.10.0.tar.gz"
    sha256 "f513588da599943e0cde4e32cc9879e825d58720d6557062d1098c5ad80080e1"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/48/20/a38a078b58532bd44c4c189c85cc650268d1894a1dcc7080b6e7e9cfe7bb/subprocess-tee-0.3.5.tar.gz"
    sha256 "ff5cced589a4b8ac973276ca1ba21bb6e3de600cde11a69947ff51f696efd577"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.10")
    %w[ansible jsonschema yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: false
        tasks:
        - name: ping
          ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
