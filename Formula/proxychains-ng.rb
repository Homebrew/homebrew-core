class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.16.tar.gz"
  sha256 "5f66908044cc0c504f4a7e618ae390c9a78d108d3f713d7839e440693f43b5e7"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "99ceac372f00a1ce0834d400e58a2f22719bbd0c6cf97c1e522ca978cd8dc1bc"
    sha256 arm64_big_sur:  "6a8e236352cf019230c9c65845b76263018b25f1a05317752eab45b2055b2140"
    sha256 monterey:       "c1c7e76c78d7f5e0917a17605caf2f4109491df05322faa7a056d65f72a928cd"
    sha256 big_sur:        "1672e57460c43b61c1b40b18db1015a9a2e4156d202687bb8480b76d1d987df0"
    sha256 catalina:       "afdbb2881164696d82c98f03cb24f299d06cd1cd8bc42ae2e7554215f2576a55"
    sha256 x86_64_linux:   "999f3b69f901f7f5d1604e28193a0fd585f4e4e92346e1876c25313a6c1202b8"
  end

  # Fix regression in detecting linker options, resulting in build failure for v4.15
  # Patch included upstream, remove on next release
  patch do
    url "https://github.com/rofl0r/proxychains-ng/commit/7de7dd0de1ff387a627620ac3482b4cd9b3fba95.patch?full_index=1"
    sha256 "dd38fec48f675e17207e320d6f708d7c0c747de57cdd8aafb59bbb0ab805a984"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
