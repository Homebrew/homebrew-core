class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application."
  homepage "https://lostpackets.de/khal/"
  url "https://pypi.python.org/packages/66/7c/6c4f2f9ca092bfb60c1328324e2533858af6a5b89a32c168836cfe9dcbba/khal-0.8.4.tar.gz"
  sha256 "2e5c41eadf83c8f175dc05816571e747da921b025e4acc6b287c109b6e237e0f"
  revision 1

  head "https://github.com/pimutils/khal.git"

  bottle do
    sha256 "6884cba5ffe6ddd9262eae2567940e9e6b89c85d893647aa53b930933714a1f3" => :sierra
    sha256 "415cb9c8af29bde339fcac14b54953ff5ed03363af155ee737380aef03e9335e" => :el_capitan
    sha256 "d37998ca94d896c89f8b12a0c3da5fa9af9ddfbf4d2eb2bbfdb8068fa8971d7f" => :yosemite
  end

  depends_on :python3

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/18/c6/ce0c132a90b5f5f52cce68292c8f0bee55b73994148bda0540f773922571/click-log-0.1.4.tar.gz"
    sha256 "dc6275b7d8f87512a22d9806ccc845f474825edd82ad37925a36ba156c887570"
  end

  resource "click-threading" do
    url "https://files.pythonhosted.org/packages/72/a5/0d72a73e085d8943c82dee5a0713ae1237f8cd59a0586fa87ecebb5320fe/click-threading-0.4.0.tar.gz"
    sha256 "1823fac05f6b7705ab15956512a06d1b634beb4bbf99e115cab4fc4f6d1436d3"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/3f/40/a479fd8d450e06ab0965227b3231ac3c4479dbaf424fdbdd1045809dc434/icalendar-3.10.tar.gz"
    sha256 "472f01da00e1e28eaf0cf03cc872c4cbce22dab50629ea9e72470761c6b45505"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/59/78/1d391d30ebf74079a8e4de6ab66fdca5362903ef2df64496f4697e9bb626/requests-toolbelt-0.7.0.tar.gz"
    sha256 "33899d4a559c3f0f5e9fbc115d337c4236febdc083755a160a4132d92fc3c91a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/a0/41/c722d033d62f1b3aa01ed55b9ca03d049e72bba1c08c60150a327ba80add/tzlocal-1.2.2.tar.gz"
    sha256 "cbbaa4e9d25c36386f12af9febe315139fdd39317b91abcb42d782a5e93e525d"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "vdirsyncer" do
    url "https://files.pythonhosted.org/packages/63/c0/8f2305a3a4cf0ed0b30b430f90064139fed5ea6081a99798c27e62c0ed93/vdirsyncer-0.12.1.tar.gz"
    sha256 "3fbba82d5c687238698799799521978bffe72f87b911a267a9c1933b10bd7df8"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
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
    (testpath/".config/khal/khal.conf").write <<-EOS.undent
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
