class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2026_07_28.f8df3f1.tar.xz"
  version "2026_07_28.f8df3f1"
  sha256 "fcfeb5fbdf775bcc48edc1d5eac8a6d57bc333f8e67b714149376d36061416f0"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "4bf02bbcbd724740f4f79fdaf59a7ef2352133703040e0f7ca7cead8d73a9b67"
    sha256 cellar: :any, x86_64_linux: "d0621b7850b735ec925a1f56c01931629e1f0fa71e44b077948284f7cf004f78"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    require "pty"
    PTY.spawn("#{bin}/passt --version") do |r, _w, _pid|
      sleep 1
      assert_match "passt #{version}", r.read_nonblock(1024)
    end

    pidfile = testpath/"pasta.pid"
    begin
      # Just check failure as unable to use pasta or passt on unprivileged Docker
      output = shell_output("#{bin}/pasta --pid #{pidfile} 2>&1", 1)
      assert_match "Couldn't create user namespace", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
