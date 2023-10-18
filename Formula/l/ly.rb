class Ly < Formula
  include Language::Python::Virtualenv

  desc "Parse, manipulate or create documents in LilyPond format"
  homepage "https://github.com/frescobaldi/python-ly"
  url "https://files.pythonhosted.org/packages/9b/ed/e277509bb9f9376efe391f2f5a27da9840366d12a62bef30f44e5a24e0d9/python-ly-0.9.7.tar.gz"
  sha256 "d4d2b68eb0ef8073200154247cc9bd91ed7fb2671ac966ef3d2853281c15d7a8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2ef5e552612d2643c59c048ca9d5e3330046f0e4d2556187cd14b7ef60c50d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e374bc0514419daf40b0b0d3cd155c78965bfca7f2838c900d4376b89fbeaa25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54261b4b91eadceb96591caedfd3b04025512dbbcfcdb7fff274eb74f3f80161"
    sha256 cellar: :any_skip_relocation, sonoma:         "d41b49ac7e4a7d6cbcc008d5416e8bf3b333435b41a958d07a1214ab9b2b2ff8"
    sha256 cellar: :any_skip_relocation, ventura:        "9c1fcdfab67e6fc216a70c03e740282d319caed4708425dd4bb8857eba636a1a"
    sha256 cellar: :any_skip_relocation, monterey:       "31df1c922525d5e55d5c7d79f94acdb454e78918b9917fa6f3c2e3c2c7b3e7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b168c0e6b81049af49c920e12792b989f0b1e91584f2df3725e7023d38ee3ca"
  end

  depends_on "python@3.12"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
        .opt_libexec/"bin/python"
  end

  def install
    virtualenv_install_with_resources

    site_packages = prefix/Language::Python.site_packages(python3)
    python_version = Language::Python.major_minor_version(python3)
    site_packages.install_symlink libexec/"lib/python#{python_version}/site-packages/ly"
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    output = shell_output "#{bin}/ly 'transpose c d' #{testpath}/test.ly"
    assert_equal "\\relative { d' e fis g a b cis d }", output

    system python3, "-c", "import ly"
  end
end
