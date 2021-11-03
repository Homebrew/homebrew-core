class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/8c/dc/ebd5c077651ac901bdbbf121082d27911f5caefbb1b7bf82540c5fb89697/isort-5.10.0.tar.gz"
  sha256 "e52ff6d38012b131628cf0f26c51e7bd3a7c81592eefe3ac71411e692f1b9345"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e4920501201a94ee9a6ea4990b9fa8a259797be211f516c092f2ab800a151d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36eca38b43c2fe314d024a1995d0953cf155862dbc7f00f6d0a34edb742ea513"
    sha256 cellar: :any_skip_relocation, monterey:       "def6ef28d9b0677a6532156a274d4812e36a39e99ac27f23173761269eb05044"
    sha256 cellar: :any_skip_relocation, big_sur:        "50b4352cc80c9b4064b43889478d62d928fbe4b1046682a75425101008388a07"
    sha256 cellar: :any_skip_relocation, catalina:       "d3b566b024853af9f4b15f21a67e24bfe388d3091d083070e3a0a751d304c97b"
    sha256 cellar: :any_skip_relocation, mojave:         "04253871a201d55662ac4467f41c10154801199b8d751fee858f752681f3335e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4729c47853441bbb0989cf58ebe6be207e8486316f7c9116f9e1595596517bcd"
  end

  depends_on "python@3.10"

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
