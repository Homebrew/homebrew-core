class ClosureStylesheets < Formula
  desc "Extended CSS preprocessor, linter, and internationalizer"
  homepage "https://github.com/google/closure-stylesheets"
  url "https://github.com/google/closure-stylesheets/releases/download/v1.5.0/closure-stylesheets.jar"
  version "1.5.0"
  sha256 "aa4e9b23093187a507a4560d13e59411fc92e285bc911b908a6bcf39479df03c"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "closure-stylesheets.jar"
    bin.write_jar_script libexec/"closure-stylesheets.jar", "closure-stylesheets"
  end

  test do
    (testpath/"test.gss").write <<~EOS
      @def A 5px;
      @def B 10px;
      .test {
        width: add(A, B);
      }
    EOS
    system bin/"closure-stylesheets", testpath/"test.gss", "-o", testpath/"out.css"
    assert_equal (testpath/"out.css").read.chomp, ".test{width:15px}"
  end
end
