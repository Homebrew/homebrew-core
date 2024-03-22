class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "455fabcbd4a5a5dc5e05374a71b62dc0b08ee865c2ba398e9dc9acac1ea1836a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2d9a69320d9e55e3989311435e8bf7d999a54af949ce5d1d1726003642ac0536"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

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
