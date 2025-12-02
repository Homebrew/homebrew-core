class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.5.tgz"
  sha256 "480e3414ab6cedca837721c756b7d64b01a84d2d0e837378d98444e2f63a7c01"
  license "ISC"

  livecheck do
    url "https://dmalloc.com/releases/"
    regex(/href=.*?dmalloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5739c56456cf07b59f8c884ca56e499aa3e618c2712500819c0457af57018b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2406c340e3935d9f228d695c270eb5fd74abef38bafa84f10bded7826c8e8c80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5326a45ed099179ae2f05299e3bf0e90b2f7b037594cf175da72830963687acf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc77030dce1a9f169758cd306be4a70d322479044dd598ce74e7733bbe0a7d71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f328197f63c96ff0ce40846bb242b3e1d04985567893adefd2d47f79f6f96d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e1beff8a66f4a5d7a90fa8c5f9836ed79b9241ab642966d82550916a3af5c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7768789dadca658d2591b23ad1be950f3c0930dc5a81eff33d16cc2d31ab305b"
    sha256 cellar: :any_skip_relocation, ventura:        "01adf9d08a79145edccb9004602becb64b659062815b15ce5504a80937c80970"
    sha256 cellar: :any_skip_relocation, monterey:       "e81b6c8a327baa3612aed45f6dfc157885344bb64f925dcf1cb00d12acfb2f9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "300f9e7b54c15071bc36fb861cc6b75ef671052c8be6096a99314b1ca0077565"
    sha256 cellar: :any_skip_relocation, catalina:       "770699ff908a65026ecdebbe57272a50e57f60341c2918302ee4b6729e866533"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "37749e2907a9db34407034a0c00e0f72e96584049a9daea5de8239e654731501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c170666de851ea2229c7c7e5dbd2d45960d8033bae31ceffd7eaf5289c1c7aba"
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system bin/"dmalloc", "-b", "runtime"
  end
end
