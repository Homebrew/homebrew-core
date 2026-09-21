class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/a1/a0/8866b4c6f894af0eb10e4964157f3241dd4117700fc010e7825471d51a13/bagit-1.9.0.tar.gz"
  sha256 "9455006c2d1df88be95ec1fccabc5ea623389589ea4c85b3d85bd256f29d7656"
  license "CC0-1.0"
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cd75590862c752f2d6fa722470125ef7eb0c50bcace9dff268adfa600a71123d"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"bagit.py", "--source-organization", "Library of Congress", testpath.to_s
    assert_path_exists testpath/"bag-info.txt"
    assert_path_exists testpath/"bagit.txt"
    assert_match "Bag-Software-Agent: bagit.py", File.read("bag-info.txt")
    assert_match "BagIt-Version: 0.97", File.read("bagit.txt")

    assert_match version.to_s, shell_output("#{bin}/bagit.py --version")
  end
end
