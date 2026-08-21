class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://andre-simon.de/doku/ansifilter/en/ansifilter.php"
  url "https://gitlab.com/saalen/ansifilter/-/archive/2.23/ansifilter-2.23.tar.bz2"
  sha256 "ff9efcfe8623593a54cd7bec2499711ec2a49a425ab50c61f2148c6d7450d525"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df4619471e2f831a7964c67ed54c85640697d9d482347c7619fb235a265dd674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5530b0be66b1bcf431848fa05c96c0a1ca46a9e57053c4a5ef525e0fa1450b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23c823ac7ac45f9235d468a4e4c91017f8f49705f08249f969bfbfff04dbe684"
    sha256 cellar: :any_skip_relocation, sonoma:        "db931624878ee3e4acd1efccedb770035c90bfdf209d9cb8654f0abeb0aadf98"
    sha256 cellar: :any,                 arm64_linux:   "01f4a5303e79fa2756a3a3f5945cf25db9b12b9a245c434dac8ff92cd32bb44d"
    sha256 cellar: :any,                 x86_64_linux:  "393a1cdaf31a9a74d34e9e8b92dd3de3066d90b0b84afb2a0c297195b737039e"
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
