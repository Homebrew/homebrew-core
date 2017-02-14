class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application."
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.2",
      :revision => "465e0a0123fa08e6c0776d59448862615f3bcff0"
  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 "4b6f3c5ab1ec0aeb0fd691b9b09e2838ae747ed80776d12cb8cd40072920b469" => :sierra
    sha256 "f1ee0bc32a3eb6b9a8ad8dfda85226e5b9e13c876a7e9a28117389cf29dd5d99" => :el_capitan
    sha256 "0574d013785a6e605d0ab59df000d72888fdebadd26acd473e36e259dfbb14dc" => :yosemite
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
