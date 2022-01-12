class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.0.32.tar.gz"
  sha256 "0ffd17a185322779d14d9a64c39120900f1e0cc3297b18679a933f5f6ba06a75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a222e9fd1ad65419acc1efe6e8c8d88e55d31fd5ed88dcbbf661ed0e5501a0e"
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
    assert_match "conmon: Container ID not provided. Use --cid", shell_output("conmon 2>&1", 1)
  end
end
