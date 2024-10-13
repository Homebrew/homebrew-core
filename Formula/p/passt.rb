class Passt < Formula
  desc "User-mode networking daemons for virtual machines and namespaces"
  homepage "https://passt.top/passt/about/"
  url "https://passt.top/passt/snapshot/passt-2024_09_06.6b38f07.tar.xz"
  version "2024_09_06.6b38f07"
  sha256 "5e0d33c6cc45a482d1be2375c5b4918fa799bde381321a48c11ef48e34466ccc"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "git://passt.top/passt", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de300ced6ff7d736b7f9717357b063e56654af22095dd874e3ee5e259a76be6b"
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
