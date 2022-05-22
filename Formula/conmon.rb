class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "676bcd5eb7d51cd5510ac9b7513726d9d0e42698fb01e763c25aad8f0c7edde4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98069e6b487c0421d6bbc61038d35e257ed772a1fe111fa72a0585c2addd1621"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libglib"
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
