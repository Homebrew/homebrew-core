class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/32/21/7f9967a2d5a37d8f77e793ba4c173d0e1e59195028c997a9947b73b652f4/gcovr-8.2.tar.gz"
  sha256 "9a1dddd4585d13ec77555db5d6b6a31ee81587ea6fc604ff9fcd232cb0782df5"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7f77441e25db28d5cc139e25d0da7ea0b9b2b0c7bbb58993940ab5657fde4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06781eb1ecbc23c17eea3c2afae02943ab7426a182a624e7c4646cb5567de0ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a25c3ff943643010a69b455916cd4013d3cdf8cc8f3d5feffd3268fed8acba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "899ad67d226162abaa2605d48206670ca0fae72cebeb6723296b3040ce510c35"
    sha256 cellar: :any_skip_relocation, ventura:       "8d862a1fbff7976bcd5b23216d3967b5689a3af5d667fa5b9b2b6fa06481370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdae1740841ad220dbbe6daff2479e5e3f0a3988d0777e61d2dbb5eee557d766"
  end

  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
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
