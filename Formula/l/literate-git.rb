class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/7b/cc/1a6c994c90fa34cfa8e90e017c80f838b149fd0262daa24cdb930c091b48/literategit-0.5.0.tar.gz"
  sha256 "88f9e95749d427c98a397a9c38a845d9760cf3451424441bc217c53c1ec835bd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "38acae8305d64c0a5f9fdddc6747b0127c4bf05e5590ae9fd333ebab7ac16928"
    sha256 cellar: :any,                 arm64_sonoma:  "ad2cb4dedf6cb0d0e7f3b0f0cb6e3f71ae9f9bfef06a301241ac2d743ed1afb0"
    sha256 cellar: :any,                 arm64_ventura: "19821fcb42961968d770cc268ad56d92a778328837f7ea15f2fdef23da9a9cf3"
    sha256 cellar: :any,                 sonoma:        "c011a534ff7d849844de0181c510512cdc288c48501a481f6d18cf3866c066dc"
    sha256 cellar: :any,                 ventura:       "bd2fc52016929729adb8e999611235177ee9b6c494e137b8cbedddbe1f2a54ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df5ebfbcfb6385272f1ed1dd383fd43983df87aeeed504cb68a74eae47dd6901"
  end

  depends_on "libgit2"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
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
    url "https://files.pythonhosted.org/packages/05/92/22e3645e352562ea9bfc89aeaeb9a76feb79e20907b18bc25d5ca340b50f/markdown2-2.5.1.tar.gz"
    sha256 "12fc04ea5a87f7bb4b65acf5bf3af1183b20838cc7d543b74c92ec7eea4bbc74"
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
    url "https://files.pythonhosted.org/packages/a4/85/c848cdf44214bf541c4a725a0a6e271f8db9f18cfccef702d53f83f1e19a/pygit2-1.16.0.tar.gz"
    sha256 "7b29a6796baa15fc89d443ac8d51775411d9b1e5b06dc40d458c56c8576b48a2"
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
