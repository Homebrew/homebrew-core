class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://andre-simon.de/doku/ansifilter/en/ansifilter.php"
  url "https://gitlab.com/saalen/ansifilter/-/archive/2.24/ansifilter-2.24.tar.bz2"
  sha256 "e1f2ae665e49631c30f483e9048d4f6c7fc6f4854d945fbe3c68995c6bf5ec65"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce2d3b8f8b9daf5eb918fc434b3b463f535e831baa3019a29bcc29342e979de6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ead30ff7bba9161b224ae343fe5ff3580c0d0e23e8ea700a99ff11e8fd8569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "464237c8e8b65a55a9d0230659d8f3f6fedb67fec2803ba3b5b3802f6e8e91d1"
    sha256 cellar: :any,                 arm64_linux:       "ee7a9eb4a413f662525810d547f672a6f57702bf58dfde372ec2193f60b8979b"
    sha256 cellar: :any,                 x86_64_linux:      "cf3d002314bd6fa6f9ca475909141cfcc3b2bbbbf5b6b6055525a7879e0e4a50"
  end

  deny_network_access!

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
