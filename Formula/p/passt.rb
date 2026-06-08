class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2026_05_26.038c51e.tar.xz"
  sha256 "78d9a5c11592a30ebbb35e39614d4ae5059c443f7f4f96ddce195ba3e9129172"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ce99f9dabf43d26be6bfc49a09144aec4a59eb5f8699c66ddb07bdcf25191bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7e854ec89a13b09fa1b6541bc609ce726dc129948573d29c9f833c6696f4c5d4"
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
      assert_match "Couldn't create user namespace: Operation not permitted", output
    ensure
      if pidfile.exist? && (pid = pidfile.read.to_i).positive?
        Process.kill("TERM", pid)
      end
    end
  end
end
