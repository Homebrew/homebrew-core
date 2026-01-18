class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  license "LGPL-3.0-only"
  head "https://github.com/buger/goreplay.git", branch: "master"

  stable do
    url "https://github.com/buger/goreplay/archive/refs/tags/1.3.3.tar.gz"
    sha256 "d8487e4d677546f9533b930e1d5f604628cd904f7e31a260552dfbf7b440876e"

    # Backport part of commit needed for arm64 linux support
    # https://github.com/buger/goreplay/commit/d440b3dc8f2800b8147cd968f68aa10ec8b72e3b
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f1b4493ea796d00e8d013a963a730e6f5e2d148d2c66be08f05fff8963f241ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a8ed8382f86dda7151fc370d5dd57a6df574581dd1a8b6220ae588350d374715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "116b89358d585b7eece8d89c3c3d39c671c1036db379cdb775ed1f55c394174e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68be04c49961eaf2b9bfecd1711ee12670ca219541c9d7d0947207e6135264d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe66f6fc334df036e4fe3f6cd579bc73ac6eacef6848e2c46a6e475a4874c9c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "227fba89a0ef4516c6b25e9c865c60de19731213a96f6b471ea7780f7bb72485"
    sha256 cellar: :any_skip_relocation, sonoma:         "fafb32cdb0f4c995083b3a4e3e39288601b8f7f654455edf2e8d2541e3e68d6e"
    sha256 cellar: :any_skip_relocation, ventura:        "e8da9dd64c5e41f1ae20fc6b5650ccfdbbf923bb55fffdee6609b0748fa1b559"
    sha256 cellar: :any_skip_relocation, monterey:       "be4aae24b0d4f5c8e55631a5314eb0f1f08a77c404b432b7db71b7e2d5186d82"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ff4869f7dcd7a5b830eb005940900360f31450d82538ff4208e6093e09840ce"
    sha256 cellar: :any_skip_relocation, catalina:       "822445285cbf26edb06857be8bdeb0c5a7f6df0c9a801316e1537fc1794becb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "30335e69674ba237da1cc12d9d250a222ef2f84685a2790490a4d64c4d017ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1239ddcc67670144a35dbdf90712514bc56f52ccbc755285eef6e54ed909afb1"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for gopacket)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}")
  end

  test do
    (testpath/"test").write "Hello"
    test_port = free_port
    server_pid = spawn bin/"gor", "file-server", ":#{test_port}"
    sleep 2
    assert_equal "Hello", shell_output("curl -s http://localhost:#{test_port}/test")
  ensure
    Process.kill "TERM", server_pid
  end
end

__END__
diff --git a/capture/sock_linux.go b/capture/sock_linux.go
index 1ff5cb6a..9d149fe2 100644
--- a/capture/sock_linux.go
+++ b/capture/sock_linux.go
@@ -1,4 +1,5 @@
-// +build linux
+//go:build linux && !arm64
+// +build linux,!arm64
 
 package capture
 
diff --git a/capture/sock_others.go b/capture/sock_others.go
index 0d8559b5..1e297bed 100644
--- a/capture/sock_others.go
+++ b/capture/sock_others.go
@@ -1,4 +1,5 @@
-// +build !linux
+//go:build (!linux && ignore) || arm64 || darwin
+// +build !linux,ignore arm64 darwin
 
 package capture
 
