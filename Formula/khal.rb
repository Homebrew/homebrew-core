class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.10",
      :revision => "9174f0d92f39df5d599ffe052e1f70dd2689502c"
  head "https://github.com/pimutils/khal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4214e8703e538b81c33c000d174e534cd502e447d5bb28f8813e6bac5ee23880" => :mojave
    sha256 "b9dcafb54091f8f9e274d0e934cfaf3c26baf0687139dc961853c58fa40d3fdc" => :high_sierra
    sha256 "16c0880ae011e756ca2317f55e4d33bd58e2f83b3c696e218dde8ece47e0d57f" => :sierra
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
