class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/af/4a/11b1925844ad5fc2c5da1f210650f637000ca14bdb6e9c303ab744191337/organize_tool-3.2.3.tar.gz"
  sha256 "a7b5a776dbfd4b25b5e69f400a9b6b39dd9cf4d430ef0f18bc837d424a007b77"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ba1afd2cd35d1817528db8da60480def5c16f2668bc32ad0ad19d6102f6953fd"
    sha256 cellar: :any,                 arm64_ventura:  "4eba0b0df49fc16504cb343e2f9b3672a452dc50317e45625e5c77598f517cfa"
    sha256 cellar: :any,                 arm64_monterey: "178af0c641a655445761a0e8db4c04d33f5333c04f54289e029166c88f2c8fb1"
    sha256 cellar: :any,                 sonoma:         "834494fc5719f4177b464df57d9ed85c780b2968caa610b3054993ac97582da0"
    sha256 cellar: :any,                 ventura:        "c45a6285a858d22e9575ff3857037dae54b71def3c29fc2ce5e3756e50b5bfb6"
    sha256 cellar: :any,                 monterey:       "ec2f7fd23109719d721b3b7edb4a01cfcf266e4a249330fc6b7fc32034aac3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3603e3b7ec0f82a796ec166982877eb3007c4d3a8fc2a65e9b763e163cbe2d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "libyaml"
  depends_on "openjpeg"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "docx2txt" do
    url "https://files.pythonhosted.org/packages/7d/7d/60ee3f2b16d9bfdfa72e8599470a2c1a5b759cb113c6fe1006be28359327/docx2txt-0.8.tar.gz"
    sha256 "2c06d98d7cfe2d3947e5760a57d924e3ff07745b379c8737723922e7009236e5"
  end

  resource "exifread" do
    url "https://files.pythonhosted.org/packages/5f/a6/e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87a/ExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "macos-tags" do
    url "https://files.pythonhosted.org/packages/d4/6e/e0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099d/macos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdfind-wrapper" do
    url "https://files.pythonhosted.org/packages/0e/74/148968c2665c0f2db1fbd470fbb454b1f808ea5d4cb8d75bc99f451d0ece/mdfind-wrapper-0.1.5.tar.gz"
    sha256 "c0dbd5bc99c6d1fb4678bfa1841a3380ccac61e9b43a26a8d658aa9cafe27441"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/31/b1/a43e3bd872ded4deea4f8efc7aff1703fca8c5455d0c06e20506a06a44ff/pdfminer.six-20231228.tar.gz"
    sha256 "6004da3ad1a7a4d45930cb950393df89b068e73be365a6ff64a838d37bcb08c4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/4b/de/38b517edac45dd022e5d139aef06f9be4762ec2e16e2b14e1634ba28886b/pydantic-2.6.4.tar.gz"
    sha256 "b1704e0847db01817624a6b86766967f552dd9dbf3afba4004409f908dcc84e6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/77/3f/65dbe5231946fe02b4e6ea92bc303d2462f45d299890fd5e8bfe4d1c3d66/pydantic_core-2.16.3.tar.gz"
    sha256 "1cac689f80a3abab2d3c0048b29eea5751114054f032a941a32de4c852c59cad"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/24/ac/61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257/pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/b0/c0/7eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7/pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/d4/c5/209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6ab/simplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/61/c5/c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3/types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/91/ac/5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4/xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    venv = virtualenv_create(libexec, "python3.12")
    # `macos-tags` and `pyobjc-framework-cocoa` + dependencies are only needed on macOS
    # TODO: Currently requires manual check to confirm PyPI dependency tree
    skipped = %w[macos-tags mdfind-wrapper xattr cffi pycparser]
    skipped += %w[pyobjc-framework-cocoa pyobjc-core]
    venv.pip_install resources.reject { |r| OS.linux? && skipped.include?(r.name) }
    venv.pip_install_and_link buildpath
  end

  test do
    config_file = testpath/"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim #{config_file}")
    system bin/"organize", "run", config_file
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end
