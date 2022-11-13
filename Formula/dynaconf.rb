class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/54/6f/09c3ca2943314e0cae5cb2eeca1b77f5968855e13d6fdaae32c8e055eb7c/dynaconf-3.1.11.tar.gz"
  sha256 "d9cfb50fd4a71a543fd23845d4f585b620b6ff6d9d3cc1825c614f7b2097cb39"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c5282dab6a96e7527edf65bc226fc09331b002a41a9ecb2513d05f3e14da69"
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
