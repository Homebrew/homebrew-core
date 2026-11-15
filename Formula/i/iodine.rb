class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https://code.kryo.se/iodine"
  url "https://github.com/yarrick/iodine/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "9c1017dc9ede3a4300ce3026d98b502897e76ae93072ae5045d97b169516f84b"
  license "ISC"
  head "https://github.com/yarrick/iodine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c23d061dc129cf30f6cdcdf2758904f08291da21d3310dfc659f18928d328e12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dca30894391b99f3d335c8cb9f7250c6ea721bda437f7b11efe238057dbe2254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96d12e4e2462963d731ae4774c5376d554d2278550816228d9e1bfafac5f5ece"
    sha256 cellar: :any,                 arm64_linux:       "28b91fd060c383e4335adc2ee159e8a3d8bc92ae1d3d41b0c9c520e152f5e874"
    sha256 cellar: :any,                 x86_64_linux:      "997a362cbade1270b400c7fead51055de11fbf0e9fb9b2ff5fa669196339462d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Both executables require root.
    shell_output("#{sbin}/iodine google.com 2>&1", 255)
    shell_output("#{sbin}/iodined 10.0.0.1 google.com 2>&1", 255)
  end
end
