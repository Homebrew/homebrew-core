class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/7b/cc/1a6c994c90fa34cfa8e90e017c80f838b149fd0262daa24cdb930c091b48/literategit-0.5.0.tar.gz"
  sha256 "88f9e95749d427c98a397a9c38a845d9760cf3451424441bc217c53c1ec835bd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0a3f5a47383da7bec77d1b5b767fc1a345926b490b347ea650c082e87aa4797"
    sha256 cellar: :any,                 arm64_ventura:  "49ae359bfc9d5d3742e637bc5189bf67e2fa43741b553fa89dc6b35973f5cc52"
    sha256 cellar: :any,                 arm64_monterey: "8fdbe2da2f31c81d2c47db219d3f0d92f7e4f1896c3d8a25c6219b05b52aae1d"
    sha256 cellar: :any,                 sonoma:         "3c16c62933a94a0528218288753fdd1c170637a09ff2bc7fedd9c92f41d2559c"
    sha256 cellar: :any,                 ventura:        "b937c36af05b123ca4eea2fbf567aab095831e9ae1f28e2ec8d7319637f249d2"
    sha256 cellar: :any,                 monterey:       "9dc8482f8220023295f0da1171a0678fc8e1b193d5a3a4ca208c33ba3b587ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d36127509cce2264db73fc650ab5d434221008e735e7fbf098b7e9b511b1bd"
  end

  depends_on "libgit2"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/1e/bf/82c351342972702867359cfeba5693927efe0a8dd568165490144f554b18/cffi-1.17.0.tar.gz"
    sha256 "f3157624b7558b914cb039fd1af735e5e8049a87c817cc215109ad1c8779df76"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/da/00/3c708de5bffa0494daf894d2e8e2b6165f866ef3ae7939546fae039b5f0e/markdown2-2.5.0.tar.gz"
    sha256 "9bff02911f8b617b61eb269c4c1a5f9b2087d7ff051604f66a61b63cab30adc2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/53/77/d33e2c619478d0daea4a50f9ffdd588db2ca55817c7e9a6c796fca3b80ef/pygit2-1.15.1.tar.gz"
    sha256 "e1fe8b85053d9713043c81eccc74132f9e5b603f209e80733d7955eafd22eb9d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
