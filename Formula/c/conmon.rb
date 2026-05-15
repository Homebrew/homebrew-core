class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "814fb5979a3a4b8576b1f901e606b482bebb41cb7e57926e6d5765ee786b96d3"
  license "Apache-2.0"
  head "https://github.com/containers/conmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ad2a36cee01c75c27125ece2507f51cd3b5e6ffec84ec76cbd23c16315896204"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08eafee8471ae1ac41c2a408fefdb5059b5d180f84ad17ece149976a661c034b"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"

  def install
    system "make", "install", "PREFIX=#{prefix}", "LIBEXECDIR=#{libexec}"
  end

  test do
    assert_match "conmon: Container ID not provided. Use --cid", shell_output("#{bin}/conmon 2>&1", 1)
  end
end
