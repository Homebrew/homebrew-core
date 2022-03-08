class Lv2 < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.2.tar.bz2"
  sha256 "4e891fbc744c05855beb5dfa82e822b14917dd66e98f82b8230dbd1c7ab2e05e"
  license "ISC"
  revision 2

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "914671ca391bcb5891e113fbab56c19c96ca01dcf457e67f576e7e27f1fbf5e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79540e13a9bdda3d1c2acc0a2df70fe2b8e8fdac5acbec734b67988f651b729d"
    sha256 cellar: :any_skip_relocation, monterey:       "36a3722dbb6b4535194764addba33f1c371a3d88eb1c108f42432e6b573910b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbdb22d95177e43b08d7f4fb8cbd5804148ccef88213eb7c4edded113856931c"
    sha256 cellar: :any_skip_relocation, catalina:       "08171ca0b61462913727fb6781dd9e96672c065c9974cd64e59fbbe162e37175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620cdecec709b88c41a7196916adc8f92da85837442ecf8df31433e4431ddda8"
  end

  depends_on "python@3.9"
  depends_on "six"

  # importlib_metadata can be removed after switching this formula to use python@3.10 (or newer)
  resource "importlib_metadata" do
    url "https://files.pythonhosted.org/packages/73/0f/def168c6162596051dcc6acaffc4984ec742eb0c79ce02e51ddc11772b1c/importlib_metadata-4.11.2.tar.gz"
    sha256 "b36ffa925fe3139b2f6ff11d6925ffd4fa7bc47870165e3ac260ac7b4f91e6ac"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/15/06/d60f21eda994b044cbd496892d4d4c5c708aa597fcaded7d421513cb219b/Markdown-3.3.6.tar.gz"
    sha256 "76df8ae32294ec39dcf89340382882dfa12975f87f45c3ed1ecdb1e8cefc7006"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "rdflib" do
    url "https://files.pythonhosted.org/packages/42/ff/00084798ba8d21f9e79044c4b8e56d0fca4bb7dd428ae693bcbfdbaa4a06/rdflib-6.1.1.tar.gz"
    sha256 "8dbfa0af2990b98471dacbc936d6494c997ede92fd8ed693fb84ee700ef6f754"
  end

  # Dependency of importlib_metadata, remove with importlib_metadata
  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
  end

  def install
    # Python resources and virtualenv are for the lv2specgen.py script that is installed
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    rw_info = python_shebang_rewrite_info("#{libexec}/bin/python3")
    rewrite_shebang rw_info, *Dir.glob("lv2specgen/*.py")

    system "python3", "./waf", "configure",
           "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}/lv2"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    (pkgshare/"example").install "plugins/eg-amp.lv2/amp.c"
  end

  test do
    output = shell_output("#{bin}/lv2specgen.py --help")

    # lv2specgen.py will only display help text if it is able to load required Python modules
    assert_match "Write HTML documentation for an RDF ontology.", output

    # Pygments support in lv2specgen.py is optional, ensure that there were no errors in loading Pygments
    refute_match "Error importing pygments, syntax highlighting disabled.", output

    # Try building a simple lv2 plugin
    dynamic_flag = OS.mac? ? "-dynamiclib" : "-shared"
    system ENV.cc, pkgshare/"example/amp.c", "-I#{include}",
           "-DEG_AMP_LV2_VERSION=1.0.0", "-DHAVE_LV2=1", "-fPIC", dynamic_flag,
           "-o", shared_library("amp")
  end
end
