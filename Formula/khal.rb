class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application."
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.3",
      :revision => "1c41fae70eac6a138d68e84dbd971d13aff6fdee"
  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 "ac5dec515cd20854e4c88fe3e374bff102eb4c3870111f02b94ddb29acc36e7b" => :sierra
    sha256 "6952b6e6bc9642a9d2e65d89c155c8f0d6b662df1e9962ad8903c6092cda8e19" => :el_capitan
    sha256 "b55e9a6dd5e7dc0378148a01cb8aa91db023b6513e2becdbee24bcf14b3b6276" => :yosemite
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".calendar/test/01ef8547.ics").write <<-EOS.undent
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
    (testpath/".config/khal/config").write <<-EOS.undent
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
