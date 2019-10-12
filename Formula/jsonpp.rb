class Jsonpp < Formula
  desc "Command-line JSON pretty-printer"
  homepage "https://jmhodges.github.io/jsonpp/"
  url "https://github.com/jmhodges/jsonpp/archive/1.3.0.tar.gz"
  sha256 "dde8ea9b270a79cd2b2f40824f89abc5270bd360122d87ab04b4361c0015d941"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2b84ea4f8d4a4177064c1fbf024876439175c4e8c6576b33f93399c72afe3a5a" => :catalina
    sha256 "7c8dd8c69321e42c29e075a658840167138d16820ba6a0dd5f2f2425c87a569b" => :mojave
    sha256 "d81995103192bb58f66d7089939eb6682f117a7044d3a84804db62b4c31a3c81" => :high_sierra
    sha256 "219f8a6bfdf1d0e8435fa1c1fdf0cc22b91cae8ec7d62581d312927fabcf9388" => :sierra
    sha256 "3161f55711eea589c5036078fbf3a5df47484767f025adda7c0692d4dda5f2b4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"jsonpp"
  end

  test do
    expected = <<~EOS.chomp
      {
        "foo": "bar",
        "baz": "qux"
      }
    EOS
    assert_equal expected, pipe_output(bin/"jsonpp", '{"foo":"bar","baz":"qux"}')
  end
end
