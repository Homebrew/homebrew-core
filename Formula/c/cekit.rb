class Cekit < Formula
  include Language::Python::Virtualenv

  desc "Container Evolution Kit"
  homepage "https://cekit.io"
  url "https://files.pythonhosted.org/packages/c6/b0/12fffe7912cf673213a7422353e167b8d6415cce82a20005e5b63d9a465a/cekit-4.14.0.tar.gz"
  sha256 "ccfd56a3cf7140e448b8a22a1357a300fc662480854b5bd70c6f74c2530b22fa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3f67a2079625296cab085ccf82c68fcfff6904f8a04041df9fa329693ce2e3d"
    sha256 cellar: :any,                 arm64_sonoma:  "28d6bba702f3450b6618f7b2b50bba5e700b6b85c4d12e20b42fa597dfe166fa"
    sha256 cellar: :any,                 arm64_ventura: "860bca53e9ab0e83b36c15d6242467d996fca1b29f8367619caff88ba8317434"
    sha256 cellar: :any,                 sonoma:        "2018d73c01ec3490d485e745ca57315c61063a81570355623bd7597c1128f9b8"
    sha256 cellar: :any,                 ventura:       "5e76d111b2f93f3975f3eece8f0c0e0bf4a76224f501c955c5d3777e98a0c93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d6a14d90541ba0aafa333acbc7e09bf86d7e2185c4b7eec8ecba5670fbbf62"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cekit", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cekit --version")
    (testpath/"test.yml").write <<~YAML
      schema_version: 1
      from: "scratch"
      name: &name "test"
      version: &version "0.0.1"
      description: "Test Description"
    YAML
    assert_match "INFO  Finished!",
shell_output("#{bin}/cekit --descriptor #{testpath}/test.yml build --dry-run docker 2>&1")
    system bin/"cekit", "--descriptor", "#{testpath}/test.yml", "build", "--dry-run", "docker"
    assert_predicate testpath/"target/image/Dockerfile", :exist?
    assert_match "FROM scratch", File.read(testpath/"target/image/Dockerfile")
  end
end
