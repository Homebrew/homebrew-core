class Flock < Formula
  desc "Lock file during command"
  homepage "https://github.com/discoteq/flock"
  url "https://github.com/discoteq/flock/releases/download/v0.4.0/flock-0.4.0.tar.xz"
  sha256 "01bbd497d168e9b7306f06794c57602da0f61ebd463a3210d63c1d8a0513c5cc"
  license "ISC"

  def install
    system "./configure", *std_configure_args,
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    pid = fork do
      exec bin/"flock", "tmpfile", "sleep", "5"
    end
    sleep 1
    assert shell_output("#{bin}/flock --nonblock tmpfile true", 1).empty?
  ensure
    Process.wait pid
  end
end
