class ClosureStylesheets < Formula
  desc "Extended CSS preprocessor, linter, and internationalizer"
  homepage "https://github.com/google/closure-stylesheets"
  url "https://github.com/google/closure-stylesheets/releases/download/v1.4.0/closure-stylesheets.jar"
  version "1.4.0"
  sha256 "08c7f4c9694f9cf07e2d401af831f9208fac937e906ac65288d308fc09d2a8e3"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "closure-stylesheets.jar"
    bin.write_jar_script libexec/"closure-stylesheets.jar", "closure-stylesheets"
  end

  test do
    (testpath/"test.gss").write <<-EOS.undent
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
