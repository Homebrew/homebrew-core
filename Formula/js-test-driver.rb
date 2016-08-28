class JsTestDriver < Formula
  desc "JavaScript test runner"
  homepage "https://code.google.com/archive/p/js-test-driver/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/js-test-driver/JsTestDriver-1.3.5.jar"
  sha256 "78c0ff60a76bea38db0fa6f9c9f8e003d1bfd07517f44c3879f484abfbe87a68"

  bottle :unneeded

  def install
    libexec.install "JsTestDriver-#{version}.jar"
    bin.write_jar_script libexec/"JsTestDriver-#{version}.jar", "js-test-driver"
  end

  test do
    assert_match "QUIET", shell_output("#{bin}/js-test-driver --help", 1)
  end
end
