class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20221126.tar.gz"
  sha256 "745ea711fe06d5c57d470d21acce3c3ab866eb6afb69379a16c6d60b89bd4311"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/iputils/iputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a4c2aeac589e8e27fec7e508eae669bd861e69155e61b467eacdd5ea522e6835"
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
    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ping -V")
  end
end
