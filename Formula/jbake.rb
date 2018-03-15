class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://bintray.com/jbake/binary/download_file?file_path=jbake-2.6.0-bin.zip"
  sha256 "16ccf81446cea492e0919f9d19c2a93b55d35207bff27e938f3a9d1cc937fef8"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/jbake"
  end

  test do
    assert_match "Usage: jbake", shell_output("#{bin}/jbake")
  end
end
