class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "145b5aa1c5d1d9977ad0d15a53c11aad1e65e8233f7e0fd176ac85f67d6d6fbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1331379a65f6add068a6e1bad628c52144f8b8601c68ef14edd47765c6f86d7f"
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
