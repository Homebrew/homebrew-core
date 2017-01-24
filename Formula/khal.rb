class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application."
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.0",
      :revision => "19614f62d71128fc7660908a587c5697745d7aac"
  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 "f348d1d629bab00f473247d72bbfa9bbbaffabb4696a6e50410ff4b4c591be0e" => :sierra
    sha256 "d1a31bca0992790746e667fb795702fe5a9a69a424c0415d43ece2a4b02f0e47" => :el_capitan
    sha256 "256400d7f22f9f48e3e071ba1f7b6f3a08467d2c95246c9926e79b79f7989d0d" => :yosemite
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
