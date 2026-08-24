class Ijq < Formula
  desc "Interactive jq"
  homepage "https://codeberg.org/gpanders/ijq"
  url "https://codeberg.org/gpanders/ijq/archive/v1.4.0.tar.gz"
  sha256 "3bc925a05755f621926ac21051a257220f924bb7fa6dd85dc1367cd508b391cb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/gpanders/ijq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13d3c521194f5cf432f787a993ca5ef9c32b02953b5bb2be514f0ac2602e9bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f3a41b5f1a6924916d0e8d216da83dbdc273c253e82929b0064a93ca36a8ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f978d17e05a71ed4fc7da15ae9eb6d000900b80c4fd0eefd04ce3d9ce408dee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1d6f14e2540892f375d93666ba3f4f7eec93833d49e2e22eb7448db8603f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1a6d78030c28b2dfaf94d330d61efe313ffd778fc93a219e0f0d729da57570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2a01a981e0f6ee906a5b0d6e889c989f159c3a3f50b11f05665f8ffde6cdc2"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ijq -V")

    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'
    output_log = testpath/"output.log"

    require "expect"
    require "pty"
    PTY.spawn(bin/"ijq", "-H", "", "-M", "-n", "-f", "filterfile.jq",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      refute_nil r.expect("barbazfoo", 5), "Expected barbazfoo"
      w.write "\r"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match "\"barbazfoo\"", output_log.read
  end
end
