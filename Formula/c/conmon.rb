class Conmon < Formula
  desc "OCI container runtime monitor"
  homepage "https://github.com/containers/conmon"
  url "https://github.com/containers/conmon/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "300d21c2244e1b5e90cc62d796da3e94812bec281bae6868d6e738432155319d"
  license "Apache-2.0"
  head "https://github.com/containers/conmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bd20d8e669c8394e2122b468a31be18777fb6d6ea4dab5f0b9dbc9135f7ed832"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4b5922d020bbcbb3fa173ce7502c71db4bd7e19444ab0a9764975585837b99f1"
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
