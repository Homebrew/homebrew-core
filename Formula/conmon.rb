class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "340453f7aac43e6a1f9a5efe31f24471f8a7a997a849ad6d1ff3fb530a9e2874"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9a02b81a1d0bfc29223baa143b001b0a47284c0c430f09cb1b3d034f4a4be4e"
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
