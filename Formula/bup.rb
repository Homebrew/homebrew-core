class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.32.tar.gz"
  sha256 "a894cfa96c44b9ef48003b2c2104dc5fa6361dd2f4d519261a93178984a51259"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96005e9af68eb9bc01c01025b693bf25a0fe2aeb2318adaadc643c91f824ea3a" => :big_sur
    sha256 "0509e26be582f806e50a47b36e3656d0031e852dbac6a9a15f500365860111c5" => :catalina
    sha256 "d88b558267b83a82fd2dcec7a400558224afaf9a2dd30c910766ee62556e0dbd" => :mojave
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
