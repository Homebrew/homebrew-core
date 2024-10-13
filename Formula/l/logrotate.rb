class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz"
  sha256 "42b4080ee99c9fb6a7d12d8e787637d057a635194e25971997eebbe8d5e57618"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9ae7a765a604fa64a1f16f285f8d89dc4bf8d82e14e665c8a1f45b691721e247"
    sha256 cellar: :any,                 arm64_sonoma:   "cc989a616df04d37c0644ee673313f9a0b978c122000bccfa9fdbf3cce7e55dd"
    sha256 cellar: :any,                 arm64_ventura:  "9d16fd4af182a7110bed763ea092c38e6807bf98a2de15289052db9be87ac0ce"
    sha256 cellar: :any,                 arm64_monterey: "b4f8a2de9632fe60890087d05a3121caa140a133b629f98af4a1e5de704dcc33"
    sha256 cellar: :any,                 sonoma:         "4a262dfa8dd7faf2bfbba2ac4c1c1dbf58aaa55b5bbe9b78de2c291c53a821c6"
    sha256 cellar: :any,                 ventura:        "b66ab2b20624eb143b00bf928653507fc0dd49ad413d44eb10e18f6019f65db5"
    sha256 cellar: :any,                 monterey:       "20b2031cd8d411f41e12fc271952e9cee937c57a75429656630d8ce5e59a463f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b63035bae30c3aac9275d86db7b05c185524e15528e454b01c2d61500e35e1"
  end

  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status"
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf" => "logrotate.conf"
    (etc/"logrotate.d").mkpath
  end

  service do
    run [opt_sbin/"logrotate", etc/"logrotate.conf"]
    run_type :cron
    cron "25 6 * * *"
  end

  test do
    (testpath/"test.log").write("testlograndomstring")
    (testpath/"testlogrotate.conf").write <<~EOS
      #{testpath}/test.log {
        size 1
        copytruncate
      }
    EOS
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end
