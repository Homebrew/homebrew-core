class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20210202.tar.gz"
  sha256 "3f557ecfd2ace873801231d2c1f42de73ced9fbc1ef3a438d847688b5fb0e8ab"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/iputils/iputils.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux
  uses_from_macos "libxslt"

  def install
    args = %w[
      -DBUILD_MANS=true
      -DUSE_CAP=false
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
