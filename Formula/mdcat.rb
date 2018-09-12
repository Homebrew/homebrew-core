class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.10.1.tar.gz"
  sha256 "c946a6115e903675f8ebc786c7a628d982f2c490c68f9eb7d9986726477465d1"

  bottle do
    sha256 "d92f8e0c406d0d47d007a1833c01cb67c9e85dd1d01cd66e8c8c5bb68f210ce5" => :mojave
    sha256 "1e3e24803ce9ca7e40e1792660bfee461b9d3ebbe2db563e44c234c6829545ee" => :high_sierra
    sha256 "540c23e2f8a341adeae5dc8965ce36861ab870316b69ea6eb5eb41268df37ac6" => :sierra
    sha256 "db8fb3a05f299557b0fbe95330ed2f04f64dd6065c8b8a13d7723555ddf30021" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat #{testpath}/test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
