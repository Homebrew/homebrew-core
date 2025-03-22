class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2025_03_20.32f6212.tar.xz"
  version "2025_03_20.32f6212"
  sha256 "3d0aff0819ec1c806e82533fdd6d0034adadee34307078e1336c9542d35ee6c7"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "f6b1deeba357d720b409ff561f29ee5b5e95996577f5b3bc023c548834c815e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93a5c99331149bc6e734826900249d00471aa6aa5ff48801c58dd6bd687e774f"
  end

  depends_on :linux

  def install
    args = ["prefix=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    assert_match "passt #{version}", shell_output("#{bin}/passt --version")
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
