class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager"
  homepage "https://github.com/kraanzu/dooit"
  url "https://files.pythonhosted.org/packages/1e/d3/657415da14582454b080ca29f22596c4a3502362d14ea835d82cb8e27312/dooit-1.0.0.tar.gz"
  sha256 "7a983a83385d15469ddff463b84b53048866dfb1a4481c5878ee277c7ebb27dc"
  license "MIT"
  head "https://github.com/kraanzu/dooit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c22fc5b416c88a0680075be0015ee23c27466f66f187b4472bd7473e629ea6b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb3d6487e9daf8da2bd9260e862f64196716b4f70f12f2d2ffd55e63226594e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8038769736cf96ebb9338d4b032b224ea4578bede9acb521e382bebb29576a09"
    sha256 cellar: :any_skip_relocation, ventura:        "d8805da36b23696225cf071190dc8fc6dac86f394fd9a8e9b9045b331303408f"
    sha256 cellar: :any_skip_relocation, monterey:       "15a5ebc42c51dadc20efc5a45e15612958df848d2a525674ffdc675b9f0c0ff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "391b87a19aee92ea94be0a3095b4060706bb19ed8def81e45a92894df00b23a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07f17f88d0490e6862eb52ca9ec6f48b601248713a818a9465461d59c9fb9b8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/44/ea/cbf18a84d7b97261ec8f2d5d6ef5e1c44101189d33aca22a18bd52c4e73a/dateparser-1.1.7.tar.gz"
    sha256 "ff047d9cffad4d3113ead8ec0faf8a7fc43bab7d853ac8715e071312b53c465a"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/55/12/ab288357b884ebc807e3f4eff63ce5ba6b941ba61499071bf19f1bbc7f7f/importlib_metadata-4.13.0.tar.gz"
    sha256 "dd0173e8f150d6815e098fd354f6414b0f079af4644ddfe90c71e2fc6174346d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/f4/8d/abb58e1ed268d5ef787bf95c7e42d0f95f3aa7f9cd41ff990c25fcc8ed0c/linkify-it-py-2.0.0.tar.gz"
    sha256 "476464480906bed8b2fa3813bf55566282e55214ad7e41b7d1c2b564666caf2f"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/d6/58/79df20de6e67a83f0d0bbfe6c19bb82adf68cdf362885257eb01099f930a/Markdown-3.3.7.tar.gz"
    sha256 "cbb516f16218e643d8e0a95b309f77eb118cb138d39a4f27851e6a63581db874"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/25/f5/5b9caa98f480ba38f15236a4049ff7d7a803735081d83d4997b2b12b27d3/mdit-py-plugins-0.3.4.tar.gz"
    sha256 "3278aab2e2b692539082f05e1243f24742194ffd92481f48844f057b51971283"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "mkdocs" do
    url "https://files.pythonhosted.org/packages/ff/2c/932a6df2847c0ecf0875cd00bede939225734b2815fc866c78edb46d9e5d/mkdocs-1.4.2.tar.gz"
    sha256 "8947af423a6d0facf41ea1195b8e1e8c85ad94ac95ae307fe11232e0424b11c5"
  end

  resource "mkdocs-exclude" do
    url "https://files.pythonhosted.org/packages/54/b5/3a8e289282c9e8d7003f8a2f53d673d4fdaa81d493dc6966092d9985b6fc/mkdocs-exclude-1.0.2.tar.gz"
    sha256 "ba6fab3c80ddbe3fd31d3e579861fd3124513708271180a5f81846da8c7e2a51"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "pyyaml_env_tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/68/31/b8934896818c885001aeb7df388ba0523ea3ec88ad31805983d9b0480a50/rich-13.3.1.tar.gz"
    sha256 "125d96d20c92b946b983d0d392b84ff945461e5a06d3867e9f9e575f8697b67f"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/c7/49/f90f1df0b9b585cadbb4a288b4dc3f5604cf5e93820b4b20fd6d73f58c23/textual-0.12.1.tar.gz"
    sha256 "f826b422e39e4ca188307336f6a4f4b0a89834dab2628430b613084c70799dfd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/8d/01/865815288cb9b2cd2e7181bbe17fe55e4e3d30f29f28efcef2be4247e6a0/uc-micro-py-1.0.1.tar.gz"
    sha256 "b7cdf4ea79433043ddfe2c82210208f26f7962c0cfbe3bacb05ee879a7fdb596"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/a5/17/a31fc6b90ff861a27debd0650bfbca17e074fdc3e037f392872fad76c726/watchdog-2.3.1.tar.gz"
    sha256 "d9f9ed26ed22a9d331820a8432c3680707ea8b54121ddcc9dc7d9f2ceeb36906"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  test do
    PTY.spawn(bin/"dooit") do |r, w, _pid|
      r.winsize = [80, 43]
      sleep 1
      # Create a topic
      w.write "a"
      sleep 1
      w.write "Test Topic"
      sleep 1
      w.write "\e"
      sleep 1
      # Create a todo in the topic
      w.write "\n"
      sleep 1
      w.write "a"
      sleep 1
      w.write "Test Todo"
      sleep 1
      w.write "\e"
      sleep 1
      # Exit
      w.write "\x03"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
