class Cram < Formula
  include Language::Python::Virtualenv

  desc "Functional testing framework for command-line applications"
  homepage "https://bitheap.org/cram"
  url "https://files.pythonhosted.org/packages/38/85/5a8a3397b2ccb2ffa3ba871f76a4d72c16531e43d0e58fc89a0f2983adbd/cram-0.7.tar.gz"
  sha256 "7da7445af2ce15b90aad5ec4792f857cef5786d71f14377e9eb994d8b8337f2f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a0f3b04ef44d789fb07fe79107eb12c410dfc5794a730f3ab2825c890a76228"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cram --version")

    (testpath/"test.t").write <<~EOS
      Simple cram test
        $ echo "Hello World"
        Hello World
    EOS
    expected = "Ran 1 tests, 0 skipped, 0 failed."
    assert_match expected, shell_output("#{bin}/cram test.t")
  end
end
