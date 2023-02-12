class Conman < Formula
  desc "Serial console management program supporting a large number of devices"
  homepage "https://github.com/dun/conman"
  url "https://github.com/dun/conman/archive/conman-0.3.1.tar.gz"
  sha256 "cd47d3d9a72579b470dd73d85cd3fec606fa5659c728ff3c1c57e970f4da72a2"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "freeipmi"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    inreplace Dir["#{pkgshare}/examples/*.exp"], "/usr/share/", "#{share}/"
  end

  def caveats
    <<~EOS
      Before starting the conmand service, configure some consoles in #{etc}/conman.conf.
    EOS
  end

  service do
    run [opt_sbin/"conmand", "-F", "-c", etc/"conman.conf"]
    keep_alive true
  end

  test do
    assert_match "conman-#{version}", shell_output("#{bin}/conman -V 2>&1")
    assert_match "conman-#{version} FREEIPMI", shell_output("#{sbin}/conmand -V 2>&1")

    conffile = testpath/"conman.conf"
    conffile.write(<<~EOS,
      console name="test-sleep1" dev="/bin/sleep 30"
      console name="test-sleep2" dev="/bin/sleep 30"
    EOS
                  )

    fork { exec "#{sbin}/conmand", "-F", "-c", conffile }
    sleep 5
    assert_match(/test-sleep\d\ntest-sleep\d\n/, shell_output("#{bin}/conman -q 2>&1"))
  end
end
