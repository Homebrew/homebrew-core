class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "https://jbake.org/"
  url "https://dl.bintray.com/jbake/binary/jbake-2.6.2-bin.zip"
  sha256 "3b596da84f2268dc3074f2e794eb5119faed21e9b2487b7f975efd3fcb0b2399"

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
