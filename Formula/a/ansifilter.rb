class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://andre-simon.de/doku/ansifilter/en/ansifilter.php"
  url "http://andre-simon.de/zip/ansifilter-2.22.tar.bz2"
  sha256 "ccff41ca740b813bf9103868b5000f4243d32a75304ea929a214c49b943ecc93"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d1fc53ad6b542fc718d161242c44adc151f7e555cdd5f511304cb6a8191e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c880e01b68cabf80075bc756ad604a1a8e0f22e81947245fef8ce1db551c6426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1156071a738a3798f023c76b641f97318f4e2bf011e0e1994708672cde1302a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45348d509ab10e0cc44fb3be8320ebc5443d07de35216b1dee2d88c8275a35d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "103edd1a82bbeab8af847a4cedbc2bb8210983041ba4bd9d37ab66df777fac7b"
    sha256 cellar: :any_skip_relocation, ventura:       "14bec805d0e50a63b56cbaa6d9793b04d164b4f3c23403dd0cdb12f0e223f7bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9acd580fc2162cf91e862aa5a38dd9927cded50ad1c4736380725ab833bdae68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5c6389358d8037984ef69e04c20707e8f0b55436e814db0f4b76ebb4e2f638"
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
