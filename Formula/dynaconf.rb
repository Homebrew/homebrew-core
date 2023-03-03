class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/63/38/ed036e126de2b477ba30ad6f91932e6271ce78c1aa34181b833ee60a3b24/dynaconf-3.1.12.tar.gz"
  sha256 "11a60bcd735f82b8a47b288f99e4ffbbd08c6c130a7be93c5d03e93fc260a5e1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
    sha256 cellar: :any_skip_relocation, ventura:        "489381871dac0329723a79c90c1d4997720f54fb8a2f2a2e2bb21ddd686b242d"
    sha256 cellar: :any_skip_relocation, monterey:       "489381871dac0329723a79c90c1d4997720f54fb8a2f2a2e2bb21ddd686b242d"
    sha256 cellar: :any_skip_relocation, big_sur:        "489381871dac0329723a79c90c1d4997720f54fb8a2f2a2e2bb21ddd686b242d"
    sha256 cellar: :any_skip_relocation, catalina:       "489381871dac0329723a79c90c1d4997720f54fb8a2f2a2e2bb21ddd686b242d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "572149028f9cc11c395caf2c3af61197c4ce5b71c4a978235445ba1e63d5b025"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
