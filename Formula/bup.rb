class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.32.tar.gz"
  sha256 "a894cfa96c44b9ef48003b2c2104dc5fa6361dd2f4d519261a93178984a51259"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23515307e36409180b5d316d3c8d2bbb4d512d2001daeca9a42b4e4282604d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "301e0ea9de87b821c591dcdc780c5e0ce5bc2964a78fd695f5fd0ad673de5600"
    sha256 cellar: :any_skip_relocation, monterey:       "89b5ffe09e0d650ef66b2ba76fcff683953f5e80c2a9ec301e5b18d0a6e3132f"
    sha256 cellar: :any_skip_relocation, big_sur:        "96005e9af68eb9bc01c01025b693bf25a0fe2aeb2318adaadc643c91f824ea3a"
    sha256 cellar: :any_skip_relocation, catalina:       "0509e26be582f806e50a47b36e3656d0031e852dbac6a9a15f500365860111c5"
    sha256 cellar: :any_skip_relocation, mojave:         "d88b558267b83a82fd2dcec7a400558224afaf9a2dd30c910766ee62556e0dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a5c533688109a5bb307152dfe32279e4ae8769dbdf96f25d33718b53a940a49"
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
