class Cogapp < Formula
  include Language::Python::Virtualenv

  desc "Small bits of Python computation for static files"
  homepage "https://cog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/64/ea/4ffa8095e0b675e9961cbdcad002c09d35d4ab76ff99d61a014e9e6bcd53/cogapp-3.6.0.tar.gz"
  sha256 "ec2a9170bfa644bf0d91996fdb5576c13d7e5e848bb2378a6f92727b48f92604"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "b73ade25b3b055d47463fbc6f937bf61fb074c5af1976b96039c373d4971d44a"
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
