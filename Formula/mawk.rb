class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20200120.tgz"
  sha256 "7fd4cd1e1fae9290fe089171181bbc6291dfd9bca939ca804f0ddb851c8b8237"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f9aa87a079b35b6f93813e4016e85d102c578d8b65f2f967b0b7c5c5d869ad" => :catalina
    sha256 "802b3592430ca644c6590acad265f45ac892fe47fb37732e678afac13f8cf1f0" => :mojave
    sha256 "d113f78e1c20c8bf86fcf5ce083e206aeca58ee857e7d0a3acb0158d2b01fb45" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = shell_output("#{bin}/mawk -W version 2>&1 | #{bin}/mawk '#{mawk_expr}'")
    assert_equal version.to_s, ver_out
  end
end
