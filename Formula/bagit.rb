class Bagit < Formula
  include Language::Python::Virtualenv

  desc "Library for creation, manipulation, and validation of bags"
  homepage "https://libraryofcongress.github.io/bagit-python/"
  url "https://files.pythonhosted.org/packages/ee/11/7a7fa81c0d43fb4d449d418eba57fc6c77959754c5c2259a215152810555/bagit-1.7.0.tar.gz"
  sha256 "f248a3dad06fd3e5d329217baace6ade79d106579696b13e2c0bbc583101ded4"
  license "CC0-1.0"
  version_scheme 1
  head "https://github.com/LibraryOfCongress/bagit-python.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0be67c1d5a4b305daacc9589d5230ecebc106ccbd74ad668ce5b10d4a600039" => :catalina
    sha256 "94a987817d26843f859a1f238b6f943576bc2a2a8f36c0f01c5309c4d2cecf02" => :mojave
    sha256 "8b4295b73d506186e90b656331c1fc653ae52dd3be666b7f2695259b040b0a0e" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/bagit.py", "--source-organization", "Library of Congress", testpath.to_s
    assert_predicate testpath/"bag-info.txt", :exist?
    assert_predicate testpath/"bagit.txt", :exist?
    assert_match "Bag-Software-Agent: bagit.py", File.read("bag-info.txt")
    assert_match "BagIt-Version: 0.97", File.read("bagit.txt")

    assert_match version.to_s, shell_output("#{bin}/bagit.py --version")
  end
end
