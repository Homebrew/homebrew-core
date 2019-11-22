class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag      => "v0.10.1",
      :revision => "a6d7d62388d33459e85dfb5cf57a31c46f120769"
  head "https://github.com/pimutils/khal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a5ff88f863f07170a7ac8244c7bbec213690ed09b5b6d47a0d38f757230f790" => :catalina
    sha256 "65c0e242110629b9aba6fc3fb7dcdd0b48c256465cbf8e4bdce6eca10ef791b0" => :mojave
    sha256 "e64129f4743de673ab7ecadf45943cf920e1f263a943e13f4bb2c138cc542855" => :high_sierra
    sha256 "f3fc8e90d8d5e5f452a56954563d2c5e40f17cbda7f1552ad9ad2bd5e8bda30a" => :sierra
  end

  depends_on "python"

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
