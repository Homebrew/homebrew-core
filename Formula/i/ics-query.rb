class IcsQuery < Formula
  include Language::Python::Virtualenv

  desc "Query and filter .ics files for events, journal entries, TODOs and alarms"
  homepage "https://github.com/niccokunzmann/ics-query"
  url "https://files.pythonhosted.org/packages/20/bd/d4a149dc4140cf333cdf59c26e09777746e26d016ca0b24eb01f1945f32e/ics_query-0.4.38.tar.gz"
  sha256 "5d3ca8b0b8858de779197cf90a43eecc26e1f4c9a9e27bd52ffc9eac0ffe90d9"
  license "GPL-3.0-or-later"

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/08/13/e5899c916dcf1343ea65823eb7278d3e1a1d679f383f6409380594b5f322/icalendar-6.3.1.tar.gz"
    sha256 "a697ce7b678072941e519f2745704fc29d78ef92a2dc53d9108ba6a04aeba466"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "recurring-ical-events" do
    url "https://files.pythonhosted.org/packages/de/aa/52ba02ffb17b86b01f457b47ef19cbfb4ec1bfdbcb11c9bd88398fa3744f/recurring_ical_events-3.7.0.tar.gz"
    sha256 "abf635ec48dbfd8204dc5bea2d038a4c283a59161aab55ed140d03aa8494bb30"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "x-wr-timezone" do
    url "https://files.pythonhosted.org/packages/79/2b/8ae5f59ab852c8fe32dd37c1aa058eb98aca118fec2d3af5c3cd56fffb7b/x_wr_timezone-2.0.1.tar.gz"
    sha256 "9166c40e6ffd4c0edebabc354e1a1e2cffc1bb473f88007694793757685cc8c3"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"ics-query", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"example.ics").write <<~EOS
      BEGIN:VCALENDAR
      BEGIN:VEVENT
      SUMMARY:test
      DTSTART:20250604T044900
      END:VEVENT
      END:VCALENDAR
    EOS
    assert_match "Europe/Berlin", shell_output("#{bin}/ics-query --available-timezones").strip
    assert_match "SUMMARY:test", shell_output("#{bin}/ics-query first example.ics").strip
  end
end
