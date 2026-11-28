class Cogapp < Formula
  include Language::Python::Virtualenv

  desc "Small bits of Python computation for static files"
  homepage "https://cog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e6/d0/27e6f75da2566cbd1de24def03e035b619a5ab4fc41e9a8dbfa6b5d4f5e0/cogapp-3.6.1.tar.gz"
  sha256 "e32bc61abe21406bfc1be6559ba97cebcedf99f290742914bd0817b6e3d80bb1"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "56ff6da0f5ccceb4a48190f63edaef4c4fd81b994debd1a3d37c890c9b375d3c"
    sha256 cellar: :any_skip_relocation, all: "15c3c54cde04811f64cbd87de1954cf9d2e298a3cb607a8aea373b0f10ea00cc"
  end

  depends_on "python@3.15"

  conflicts_with "cocogitto", "cog", because: "both install `cog` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cog -v")

    (testpath/"test.cpp").write <<~CPP
      /*[[[cog
      import cog
      fnames = ['DoSomething', 'DoAnotherThing', 'DoLastThing']
      for fn in fnames:
          cog.outl("void %s();" % fn)
      ]]]*/
      //[[[end]]]
    CPP

    output = shell_output("#{bin}/cog test.cpp")
    assert_match "void DoSomething();\nvoid DoAnotherThing();\nvoid DoLastThing();", output
  end
end
