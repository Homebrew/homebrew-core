class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.10.1/fwup-1.10.1.tar.gz"
  sha256 "46a443f7461ffe7aa2228bce296d65e83d0ab9c886449d443a562ca59963a233"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3529f51fe9638c8f365ca055456924804e37f8f08ab2c076ee58ead69de50c2f"
    sha256 cellar: :any,                 arm64_ventura:  "fadeeb4c6daa8fbccc0df4990678d60dd35ef93f7d5fc10d6d06fd17e3a5a6c6"
    sha256 cellar: :any,                 arm64_monterey: "6acfdd2265ff8c0273cdea9d8e22bb88fb763f0e0e3080941dd97f95c844e46a"
    sha256 cellar: :any,                 arm64_big_sur:  "e91741c7cc946c35efbbb3d749f93da92f1c2e43a1386f3c1262229d291f3813"
    sha256 cellar: :any,                 sonoma:         "70f13ae12994fee1690a8e29630d503e64702f45adb3760b87167c46520e1b18"
    sha256 cellar: :any,                 ventura:        "f37c9a184dda1668f06ca8ca2d133b39903c93895bb4ebab58d539ce4600c2a3"
    sha256 cellar: :any,                 monterey:       "c5e7710f2c3e4f66c603d04a676c841f600f81d277b599821fdce655287ed5f1"
    sha256 cellar: :any,                 big_sur:        "10f851a5980fbd3e9e3e53a8cb590dbc2fb91eb4363a5028efca72c9741a1924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8d22e346064ac9782e138a63d3df2d754404ceeea53ea0ba80e224610e844e"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
