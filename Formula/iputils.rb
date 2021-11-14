class Iputils < Formula
  desc "Set of small useful utilities for Linux networking"
  homepage "https://github.com/iputils/iputils"
  url "https://github.com/iputils/iputils/archive/refs/tags/20210722.tar.gz"
  sha256 "6d1a44b0682d3d4b64586dbaebe61dd61ae16d6e2f4dc0c43336d0e47a9db323"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/iputils/iputils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19797621e4a456d613be44ea617efc4ed12209525136131b2c640ff82367e403"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "libxslt"
  depends_on :linux

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
