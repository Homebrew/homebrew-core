class PhantomjsLinuxX8664 < Formula
  desc "This formula is only supported for linux-x86-64 based Operaating systems"
  homepage "http://phantomjs.org/"
  url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{version}-linux-x86_64.tar.bz2"
  sha256 "86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f"
  version "2.1.1"

  depends_on :arch => :x86_64
  depends_on :linux
  
  def install
    bin.install "bin/phantomjs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phantomjs -v")
  end

end