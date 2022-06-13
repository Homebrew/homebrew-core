class Httpstat < Formula
  include Language::Python::Shebang
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.3.1.tar.gz"
  sha256 "7bfaa0428fe806ad4a68fc2db0aedf378f2e259d53f879372835af4ef14a6d41"
  license "MIT"
  revision 1
  bottle do
    sha256 cellar: :any_skip_relocation, all: "f096e9674bc79400144b98e5480ef1ee9b3d74687bab3f6132d134de961d2c86"
  end

  depends_on "python@3.10"

  def install
    rewrite_shebang detected_python_shebang, "httpstat.py"
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
