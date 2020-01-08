class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20200106.tgz"
  sha256 "f1e1240ba7626ffe920a8bd2d596864dde9f3fa7411db0165142041628b015b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "11528aabd4e0471c5bd2a58448a57d76ed03398a23e3aced31bc81d82e8e49f9" => :catalina
    sha256 "1ff2343200bcedccef77ab9222888ab004883445966f7effd24a11272de04de6" => :mojave
    sha256 "da08b49c94a33e016746d3695390aa77f31f01d71634ba7bd9d4de637dbc6a94" => :high_sierra
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
