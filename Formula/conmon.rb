class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "874909d831feac75e452562087f6ea0eb39848ef144397bdd8f0daf579c5ee85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "086920b1474bcc69454820da14ec07d0ef56eef2165d0ba69bfee0f11b018f01"
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
