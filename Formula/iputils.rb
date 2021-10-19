class Iputils < Formula
  desc "The iputils package is set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20210202.tar.gz"
  sha256 "3f557ecfd2ace873801231d2c1f42de73ced9fbc1ef3a438d847688b5fb0e8ab"
  head "https://github.com/iputils/iputils.git", branch: "master"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]

  depends_on :linux
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "libcap"

  def install
    ENV.prepend_path "PATH", Formula["libcap"].sbin

    args = %w[
      -DBUILD_MANS=false
      -DUSE_CAP=false
    ]
    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    output = shell_output("#{bin}/ping -v 0.0.0.0 -c 1")
    assert_match "1 packets transmitted, 1 received", output
  end
end
