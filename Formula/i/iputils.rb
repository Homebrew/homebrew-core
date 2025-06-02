class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20250602.tar.gz"
  sha256 "79048b6a74b4831d6ee5f50ea5122ca2123bad6adc49bc9008c126061ded6a69"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/iputils/iputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6e815977ef9efdc2a3e17a19cd2ff0360359bc9de2789f086abee5e65d1c92d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fda656bf3d0765f8d6612bb716e40d338a3511514799f8bd415104f559e9aa36"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "libxslt"
  depends_on :linux

  def install
    args = %w[
      -DBUILD_MANS=true
      -DUSE_CAP=false
      -DSKIP_TESTS=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ping -V")
  end
end
