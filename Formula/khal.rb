class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://files.pythonhosted.org/packages/d8/99/6ef24e33472b343800ffb7300e9702faa715ccd986a0a0706f01e44d8cb6/khal-0.10.5.tar.gz"
  sha256 "4eefb7ac302a26d8606db392817587a4ed94c27a15bf2ea211614a464fcf0c76"
  license "MIT"
  head "https://github.com/pimutils/khal.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41010c69b75e8e649c349fdace2f2e345f9fa7f9cb25460efa04fc57c819c19a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f8f8a8a400d24cb5702fbaf7076fe383ba03b7ee1ea718606dc149a9fba221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a6f533b2b2692ce73028a34d1951a1032ac921b898178331680c44f36f9b32"
    sha256 cellar: :any_skip_relocation, ventura:        "270cfbed9cc45ba8db1aa0594eacddeed49a6b9474d9f9fbf7d576bbd9c76321"
    sha256 cellar: :any_skip_relocation, monterey:       "0709137f58479a579f3518ab7a3429ead4a1efac8b693dedde5ebb10a34c9e27"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e7510ca67ad147afd0c3e1bb9fb58ff25b0c2c0cdbe15291b47c5681e2596c"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e5046f31842243aba85c1ec6a82af21d0e90e885e5b8876f67249b8adee64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49cf46720e4a7c20298638dc4c1b9dfd6323521b534cc53c0180d7ad606c8003"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
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
    url "https://files.pythonhosted.org/packages/8b/e2/17bae067d82e71ba56f09346cb76aa84ca0bbbee2df54eaa102f93f733bf/icalendar-5.0.2.tar.gz"
    sha256 "edc635fd9334102d409f4571fb953ef0f84ce01dd15ff83cac6afafe89c8e56a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
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
    url "https://files.pythonhosted.org/packages/5e/9f/63f7187ffd6d01dd5b5255b8c0b1c4f05ecfe79d940e0a243a6198071832/tzdata-2022.6.tar.gz"
    sha256 "91f11db4503385928c15598c98573e3af07e7229181bee5375bd30f1695ddcae"
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
