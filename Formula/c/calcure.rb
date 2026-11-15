class Calcure < Formula
  include Language::Python::Virtualenv

  desc "Modern TUI calendar and task manager"
  homepage "https://anufrievroman.gitbook.io/calcure"
  url "https://files.pythonhosted.org/packages/d7/f4/06de942b40306dc6ee2cdbef03e2b269892c996cb1fb256fee59bbdf0143/calcure-3.4.tar.gz"
  sha256 "8789ca5bb14c8018809a58cd50e7be2974e1d1cb0f67fb0af170d1cccb0cfc9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ca5b71978d27bf939451a8deb88b7356a0621a629eb49ca86164dbde90a4e5f"
  end

  depends_on "python@3.15"

  resource "holidays" do
    url "https://files.pythonhosted.org/packages/27/f2/7aa646c4ecb198a3af80a9b3dd727cf9f2659e52cee598dcd5b8ed6d9087/holidays-0.107.tar.gz"
    sha256 "2f02cdfbe41a5f14e053590f2385a932fe42f0c692aed75cb55601ad37cebb4d"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/47/2b/1bbf82d316df18c3331d9a06228819c8a5814ceda545a3e9980e52ffce1b/icalendar-7.3.0.tar.gz"
    sha256 "7bd001c8e648205e1bde5c6a5b77096598e8d0893dcf57755c6c597635620132"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "pty"

    # calcure creates ~/.config/calcure on startup but not its parent
    (testpath/".config").mkpath

    assert_match version.to_s, shell_output("#{bin}/calcure --version")

    # --task is handled inside the curses UI, so it needs a terminal
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"calcure", "--folder", testpath, "--task", "Buy milk") do |r, _w, pid|
      r.read
    rescue Errno::EIO
      # Linux raises EIO when reading from a pty after the child exits
      nil
    ensure
      Process.wait(pid)
    end
    assert_match "Buy milk", (testpath/"tasks.csv").read
  end
end
