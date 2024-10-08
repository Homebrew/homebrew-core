class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/42/19/8a72c830ab7aed71927606c6432f7edded6cd214639dc07f610e8e22496a/gcovr-8.0.tar.gz"
  sha256 "3d91ef6df6c465bab91a5b12c82c481b0fbe841d64630dcbf76a0faac7e994e8"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba754ef407113c1d8d5baee6f1dd3adbbff8a4da169fd90f7b352a23ef9ee5dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf8c7a1e0ca3dd4bd5796db14daaea934fa6ffb7114ddcaf12468027f8c7138"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d95468ae84e6782dfaefa1b30fd4423a8f9fb3b306ab70816c0003ae9e16d4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "94748f7128a086b0fce3c68c035e349aae49e7c734423e89baf92b3eca818747"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4124cf5931d6a220d8af2ea3a8d069d55c49f9a6706b19c8cd0acf6be9bac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae9187a099a62f0eba97258af69df66ff6c3e333c71600237765a12e40ce142d"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/5c/84/3f683b24fcffa08c5b7ef3fb8a845661057dd39c321c1ae16fa37a3eb35b/markupsafe-3.0.0.tar.gz"
    sha256 "03ff62dea2fef3eadf2f1853bc6332bcb0458d9608b11dfb1cd5aeda1c178ea6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
