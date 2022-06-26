class Lv2 < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.4.tar.bz2"
  sha256 "4ddc0ed20579aabbaeb4df6fb42b69949c01dc7169ab0b945c709339509e6760"
  license "ISC"

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14cd3ae47df7aa2820a32c37eb43f14c15e11d0cb61f735f481413a19cff8890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ccd000a6fbbe32384acac2fe2b166d50b85f0f1b97578f646fec99dfd1243f0"
    sha256 cellar: :any_skip_relocation, monterey:       "82ac1f317dc06bca3ded130e9343132561adca557307e490c98673de5187c1bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "93a4487dc34329c0b6e86f4ede209a2390c7d1b01fa24a8dc797440011c8a39c"
    sha256 cellar: :any_skip_relocation, catalina:       "2f5efd0e65e65ea692a3be5ebd8e6715ca67ab2a02603281b0d5049cb6da2d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18cc7b20eda1553f9d1919e7a988add9b4ebe5a970052bd0633e8a69b7923a3a"
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
