class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://files.pythonhosted.org/packages/7a/d8/9718385de260ebc07ff48c838e22fde6b05d143f1f8ab81ff1c8718d7102/khal-0.10.4.tar.gz"
  sha256 "3fdb980a9a61c0206d7a82b16f77b408a4f341a2b866b9c9fcf6a641850d129f"
  license "MIT"
  revision 1
  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "898dc596dee4d352dfd3ab4bfd2cd5302dcaad46cc5328e8a966972c71d23be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4df079afe450b880f743afbd5d3916308bde8acbc4f6ad7c8c3363714d59e61"
    sha256 cellar: :any_skip_relocation, monterey:       "e1ba60bddb5155b09728eba602543c7802caf9d9b783a05241e2328ff47c949c"
    sha256 cellar: :any_skip_relocation, big_sur:        "70fc698ac572f68d7b472a3fb1c8f89670bc8ea2da0c05ef9201a3ea529fef93"
    sha256 cellar: :any_skip_relocation, catalina:       "b00aa7ffdd6719cdf7cb7e1e51c6d680c15b2a5f75b6f5dc186d8a67e820fd90"
    sha256 cellar: :any_skip_relocation, mojave:         "f2727ec5fe1d9c5c67a5502ddfcf090c44cc3f3e1af17c3c6fa2d118a4fee8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3acb687db562fe301f40968b1325408f37de599339d634bf3c7b5620e17392"
  end

  depends_on "python@3.10"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/55/8d/74a75635f2c3c914ab5b3850112fd4b0c8039975ecb320e4449aa363ba54/atomicwrites-1.4.0.tar.gz"
    sha256 "ae70396ad1a434f9c7046fd2dd196fc04b12f9e91ffb859164193be8b6168a7a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/22/44/3d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8/click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/58/b8/9aa7963f442b2a8bfdfc40eab8bc399c5eaac5711b8919c52122e4903544/icalendar-4.0.7.tar.gz"
    sha256 "0fc18d87f66e0b5da84fa731389496cfe18e4c21304e8f6713556b2e8724a7a4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
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
