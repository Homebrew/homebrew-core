class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2.html"
  url "https://download.drobilla.net/mda-lv2-1.2.12.tar.xz"
  sha256 "8f2090433e60e90d9c4d0326970c845a3cb471951657cd9355d3dbca4040b873"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "447ee93aeb3642b63ef2b53240819f591a759b3ba9f41fec46064ad2d65a0c81"
    sha256 cellar: :any, arm64_sequoia: "5df0bbe04df736019264d64fc02e3804c3b60127e998195f52c1f540a70d3ee2"
    sha256 cellar: :any, arm64_sonoma:  "f3d7a14ce565ffae347fa5f3bc7d2a925c50826fbcb592dbcf9e36c7de1a2afb"
    sha256 cellar: :any, sonoma:        "b2b1b04ec9041f9bfcc79b9f4b4050431b1c32ea7621bc4593d3da2f21bd95d8"
    sha256 cellar: :any, arm64_linux:   "cca05417c9ec37edfdcb755f73c90fca74243c3819ca581318178939d0a76a8a"
    sha256 cellar: :any, x86_64_linux:  "258c42d6df9fa538203ade9c9c642cf881dabc02a0b973f51043145f2b5cf2e3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "sord" => :test
  depends_on "lv2"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    # Validate mda.lv2 plugin metadata (needs definitions included from lv2)
    system formula_opt_bin("sord")/"sord_validate",
           *Dir[formula_opt_lib("lv2")/"**/*.ttl"],
           *Dir[lib/"lv2/mda.lv2/*.ttl"]
  end
end
