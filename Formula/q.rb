class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.19.tar.gz"
  sha256 "cd4c60923bc40f53d974b54849f76096bf9901407c618cd0a3ccbc322aacc97d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/harelba/q.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "303c7110e72194a33115a4a0e998c8296e2a5ef6f2363151959debbd32af7d11"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8b639d8995691fa073dcdbe8e630fa133028ce97dc59d88a3129b24d8e4c038"
    sha256 cellar: :any_skip_relocation, catalina:      "b8b639d8995691fa073dcdbe8e630fa133028ce97dc59d88a3129b24d8e4c038"
    sha256 cellar: :any_skip_relocation, mojave:        "b8b639d8995691fa073dcdbe8e630fa133028ce97dc59d88a3129b24d8e4c038"
  end

  depends_on "python@3.9"
  depends_on "six"

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
