class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://files.pythonhosted.org/packages/d8/99/6ef24e33472b343800ffb7300e9702faa715ccd986a0a0706f01e44d8cb6/khal-0.10.5.tar.gz"
  sha256 "4eefb7ac302a26d8606db392817587a4ed94c27a15bf2ea211614a464fcf0c76"
  license "MIT"
  head "https://github.com/pimutils/khal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d6a327f39cfa557a621aa467b135f6629100721c3191c6cf18771fc1b52040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad91482178eb29cbaa6d538e33515c52ace893ff737dfcc454febc03f4de2c11"
    sha256 cellar: :any_skip_relocation, monterey:       "39f6c186244d57bd4f1fe562e6dee1e43f69d856890d988ffb5acea86e5bdf8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "561b01e34107fb1773b0cc8f07cf35141b2713d9e638ecdb0657bfac78cd37bd"
    sha256 cellar: :any_skip_relocation, catalina:       "ad9571f51651e1641dd21e5d94ecd5072a7cef9d9553cc40e25d46ae549140dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90fd45e297f62065662bd026022af552d421d242b14efe0286b1184ce03a371"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/55/8d/74a75635f2c3c914ab5b3850112fd4b0c8039975ecb320e4449aa363ba54/atomicwrites-1.4.0.tar.gz"
    sha256 "ae70396ad1a434f9c7046fd2dd196fc04b12f9e91ffb859164193be8b6168a7a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/1e/4b/b9e53b2fc4f7942c5698842005ad9e55dd4d932434f5bd1cf8acf3d06b01/icalendar-4.0.9.tar.gz"
    sha256 "cc73fa9c848744843046228cb66ea86cd8c18d73a51b140f7c003f760b84a997"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/df/c7/2d8ea31840794fb341bc2c2ea72bf1bd16bd778bd8c0d7c9e1e5f9df1de3/tzdata-2022.1.tar.gz"
    sha256 "8b536a8ec63dc0751342b3984193a3118f8fca2afe25752bb9b7fffd398552d3"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".calendar/test/01ef8547.ics").write <<~EOS
      BEGIN:VCALENDAR
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART;VALUE=DATE:20130726
      SUMMARY:testevent
      DTEND;VALUE=DATE:20130727
      LAST-MODIFIED:20130725T142824Z
      DTSTAMP:20130725T142824Z
      CREATED:20130725T142824Z
      UID:01ef8547
      END:VEVENT
      END:VCALENDAR
    EOS
    (testpath/".config/khal/config").write <<~EOS
      [calendars]
      [[test]]
      path = #{testpath}/.calendar/test/
      color = light gray
      [sqlite]
      path = #{testpath}/.calendar/khal.db
      [locale]
      firstweekday = 0
      [default]
      default_calendar = test
    EOS
    system "#{bin}/khal", "--no-color", "search", "testevent"
  end
end
