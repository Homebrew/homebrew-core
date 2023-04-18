class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.19.tar.bz2"
  sha256 "f9c27b1883914a1b1d4965f4c49b2be502e2a9fc9dd3f61123abeae989c354bc"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f3012c780cd7e6c52eb448bedb46e87e7a8ae1bde12a6098822afbaa0a80af9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92096687f55371d4b384bf0d933101a9603189709bb737cf135171fadfdda1eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a692940ab425a6cba2bf11ac3f494f72ea1ada05bd7fe5057b8b2c972e34171"
    sha256 cellar: :any_skip_relocation, ventura:        "cb8521b4794278954eb15d5c11ca1809664df3d1a1bbb967fb30641022153481"
    sha256 cellar: :any_skip_relocation, monterey:       "63e343ea1a8898bde4257990c9ce55d93e3e8a9bd6928c142e477b92e25afc6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "87ddd673f6e021a4156f9f0f75c08441b2bf30924d2f6a92f2bb706505df66ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1935dc618c8975e129fb53ec9f549dd6ed0aa4cc64beca446d7b73771d04568d"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
