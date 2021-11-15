class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.29.0.tar.gz"
  sha256 "f665e6dd1f26a74b5682899a877934167de2b2582e048652ecf036318477885f"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73c2409840f0151d6a3f167b6621e5e8fb1935cb97fd5d1390c3c635ee4646f9"
    sha256 cellar: :any,                 arm64_big_sur:  "e8e13392bd3adc86d94271aa6e4b0b3136c3df09b9a67a178dfcc4fbaa42615e"
    sha256 cellar: :any,                 monterey:       "6db60230fcb1c4104ea3e3eec2fb3fe347cdd6995220f54768ef0d5ce0f85a23"
    sha256 cellar: :any,                 big_sur:        "a7fcbcba9af41d5eb405122132dbee449c403fb74192b587614903d56344941c"
    sha256 cellar: :any,                 catalina:       "c83d409452660f7761f7514a0f72e9262ff6a8861b8e062d41b85a0f82a6b0d1"
    sha256 cellar: :any,                 mojave:         "ed304427db3dea3a9c18d261a1d9cc24c5ca20d5fafe5e5ae397bde10f1254b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99573601eeb2e8d7377fad27e08e1a31a002eec231d84a492ec59532bfdeb49e"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
