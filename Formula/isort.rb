class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/a9/c4/dc00e42c158fc4dda2afebe57d2e948805c06d5169007f1724f0683010a9/isort-5.12.0.tar.gz"
  sha256 "8bef7dde241278824a6d83f44a544709b065191b95b6e50894bdc722fcba0504"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ef29d8c4cf23dc882bc6c9e9557f3768c9958542158f6edd203b9be08a7c34d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8db78503c60295ff50a1808f6b0fa0ca2a6c414c861385eb4e2f840c25e41513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77befe934c459a512ba42ec882928f6560ef7a7e4973ce58067d53bcea9e37e5"
    sha256 cellar: :any_skip_relocation, ventura:        "20d60ae5afe0f3b9ad6d83e3bb862631eee8f5d567ecaa988bf69f4534beefb1"
    sha256 cellar: :any_skip_relocation, monterey:       "1664136b00f4ae23f07c20f36a0a0303e8f8480910905e398e0febea56239c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "d633c35d1ee149d1fb5fc0ac262c5fc30539363fd952a041ec4939cb1808a718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5be5b318a34e64f4c13388e7fe8582eae88a5557fe6632d8ed402d3ff071c79"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
