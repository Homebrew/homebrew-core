class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20190203.tgz"
  sha256 "daacb314029185bbef86b0df5627ad8591378d420fc32236f99f15a9a8a6b840"

  bottle do
    cellar :any_skip_relocation
    sha256 "87a7675f30db2ec57146c6e40150ef20d1cee3107a450019c731ddd356f07ad0" => :catalina
    sha256 "990c18ba7b60182eca889c9765eaf3048d35e91b974b2cdfa8e614ae85435590" => :mojave
    sha256 "dd7af444d67e691a9c80fe4192aa8ec2ebfb61b768e4836ab848e5799b6bcef0" => :high_sierra
    sha256 "8cbc0e93a86f97c9227118cabdc7813e741e875d5e4841714504e0aeee22ee0a" => :sierra
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
