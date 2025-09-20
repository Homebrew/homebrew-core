class Cntlm < Formula
  desc "NTLM authenticating proxy with tunneling"
  homepage "https://github.com/versat/cntlm"
  url "https://github.com/versat/cntlm/archive/refs/tags/0.94.0.tar.gz"
  sha256 "da9e98f26be5810abc88fd6c35c86151c6b3e8f326eb8a774902083c21985000"
  license "GPL-2.0-only"

  def install
    system "./configure"
    system "make", "SYSCONFDIR=#{etc}"
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  service do
    run [opt_bin/"cntlm", "-f"]
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/cntlm -h 2>&1")

    bind_port = free_port
    (testpath/"cntlm.conf").write <<~EOS
      # Cntlm Authentication Proxy Configuration
      Username	testuser
      Domain		corp-uk
      Password	password
      Proxy		localhost:#{free_port}
      NoProxy		localhost, 127.0.0.*, 10.*, 192.168.*
      Listen		#{bind_port}
    EOS

    fork do
      exec "#{bin}/cntlm -c #{testpath}/cntlm.conf -v"
    end
    sleep 2
    assert_match "502 Parent proxy unreachable", shell_output("curl -s localhost:#{bind_port}")
  end
end
