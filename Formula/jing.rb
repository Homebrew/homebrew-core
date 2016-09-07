class Jing < Formula
  desc "RELAX NG validator"
  homepage "https://github.com/relaxng/jing-trang"
  url "https://github.com/relaxng/jing-trang.git",
      :revision => "1e74846999bbd14ce5248acbd2be9f1e624a9846"
  version "20160828-alpha1"
  head "https://github.com/relaxng/jing-trang.git"

  bottle :unneeded
  depends_on :java

  def install
    system "./ant"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/jing.jar", "jing"
  end

  test do
    assert_match "catalogFile", shell_output("#{bin}/jing", 2)
  end
end
