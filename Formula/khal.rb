class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application."
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.0",
      :revision => "19614f62d71128fc7660908a587c5697745d7aac"
  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 "ac6ec1938a77ed608bb1539c6e0e9f85107222ec922d8c2641df7a9d92150e2c" => :sierra
    sha256 "fb1c454b3073f1cc463516e6fdc4c33bb538a9d87027e052fb6c7ca1468b084e" => :el_capitan
    sha256 "8af2631d7cced3e84656706516c8cbf03e0cca80330ee4b3e8e7d97daa456079" => :yosemite
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
