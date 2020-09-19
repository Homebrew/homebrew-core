class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.18.tar.gz"
  sha256 "db4f90602d3c45395675fa09b94293078f0ff693a94ec5fb23ae7041492fcebd"
  license "GPL-3.0-only"
  head "https://github.com/harelba/q.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e570dd5991e7da6685cc39b1daeeb2f9feb7310ea8f0ad17fbd85e811429737" => :catalina
    sha256 "8b239541f9a7a53412eccfb3c51a49ad48f9f4e3cce95f93d1dd8c067acc5887" => :mojave
    sha256 "f143dbb75cf39975e1bdf9208a4d5d3cfeeaabbc9df42df77d63df15590ab34a" => :high_sierra
  end

  depends_on "python@3.8"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # broken symlink, fixed in next version
    rm_f "bin/qtextasdata.py"

    virtualenv_install_with_resources
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
