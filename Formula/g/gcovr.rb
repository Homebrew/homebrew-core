class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/40/9f/2883275d71f27f81919a7f000afe7eb344496ab74d62e1c0e4a804918b9f/gcovr-8.3.tar.gz"
  sha256 "faa371f9c4a7f78c9800da655107d4f99f04b718d1c0d9f48cafdcbef0049079"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e179e2cd37f94eb410806766538397917fd09acf36a6dc96504f28d4f7745c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e813071f2c5b4908a39f3c6516a7a0fc3dc21a43f4edb313cf9fe2f1fe921c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daec4dc864c1887ccffca64cc88d19e3a9fb19cbc3e4c9c8c3e339a2e407a008"
    sha256 cellar: :any_skip_relocation, sonoma:        "026ab59c029c65cb1d15e13f3497fa13ccc94ace13ea30b51bf9ebadb4af9ce7"
    sha256 cellar: :any_skip_relocation, ventura:       "98460e4cc1b0983100acf000888b654b633f9364ff5cefba6e1c456d7eba09fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "762ce9c639ffa7c798e91e1bf2ca2a621467406b34657b6e400c775cec21b48a"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
