class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20250605.tar.gz"
  sha256 "19e680c9eef8c079da4da37040b5f5453763205b4edfb1e2c114de77908927e4"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/iputils/iputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "37484fe1294ed3aa7acb9e302b59eff14e200c35659d8e1efdfdfb1fad80ecae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70b1f0b987ee90225aecb3dec9012bdc1a8e25cb5f6b0530af39dae2c46970bc"
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
