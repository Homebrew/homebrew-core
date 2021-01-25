class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.0.tar.gz"
  sha256 "be27ea14c55e7a4434b2fa51d53018c7051c42fa6a3198c9aa6a1658bae0c625"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "66ae96878def0abda5c946891877604bae3490d5d5f98d9f31a234c77f705bf0" => :big_sur
    sha256 "9b985414e3e8987475a318069ef5c23817e1a9cb824c25f361ba815d708fcb5f" => :arm64_big_sur
    sha256 "18080256097344abcf595e69bc8e0b15faefbe5e9d5e36f1326e0bae8e089d5d" => :catalina
    sha256 "5227442d8a26057125ac087fb30520dc65d65ee287ce56362d08b2f12e5e6f7c" => :mojave
    sha256 "c92b075e3cfd4419cf2339b2bfd779e2df4479ab58c23b19b396c4e85bdeb300" => :high_sierra
  end

  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match /System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output
  end
end
