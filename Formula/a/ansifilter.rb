class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://andre-simon.de/doku/ansifilter/en/ansifilter.php"
  url "http://andre-simon.de/zip/ansifilter-2.21.tar.bz2"
  sha256 "5ea7cfdfd0752d5a169259da005c18b9037628036fd89d8b82624bacec9c1390"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fcb7f2e73f24c718d2052596c1b55621866d07024214cd85ff0618c09e251196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b005d0dc197d223fc17b249a946c051950cb78fb5271116bbbb44d68020c1a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45508d26fccad940ef36579ab3087faeb66b4517edff212abc336493bce7d479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2b328545637725b5a6b0d187b1c51ac6491fb70ad8a5953e2af2729d3920a20"
    sha256 cellar: :any_skip_relocation, sonoma:         "f652f4bc0010ac275be8642c627e481f133e46745398033789226295dbe76905"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae4488407625a92d4970bc8660cba23d99b551794fb03337d9531017c4da887"
    sha256 cellar: :any_skip_relocation, monterey:       "5e655b5ebd6f12c66b9f7ced9187d99f352d08496e1c9f0f5c211ac99396173d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "24194a4db72f85bf77086d3c4c975547f5e9c7a0455def0d3e20e40f2aa73187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8f6d387558594379f46240e0536e36cb2df2f1562e981901c4b65af73eb090"
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
