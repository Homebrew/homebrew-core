class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.8.tar.xz"
  sha256 "bfb26f8025189b2a01286ce6daacc2af8fe647440b40bb741dd5c397572cba5b"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e14418de0a98957bcce5796f8952e41e1409f4b13125a80cb133056b7d8a4acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66b45de376ee39540d5c05b58e79b4027a5bc038eb6c42785eb6527220261f1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ea9ff3be2137147d46691a4a7d25411c73121f53d4dadd5041759899b17a389"
    sha256 cellar: :any_skip_relocation, ventura:        "fe25334cf2b74dc002395e9cfd76e95445f4496b2870287dbac688f04389224d"
    sha256 cellar: :any_skip_relocation, monterey:       "d31ab18614d72efef3aab19db9e81a6b353064a389cd49404a72ee10f7949a45"
    sha256 cellar: :any_skip_relocation, big_sur:        "88938e80fd01b90be05a3bfde77946d8392bc9a065a69d22e0723d7db18d329c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b80b1ecd86eb7852026c657475fb738407db7ced7c015ea74300685dbfbd98"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end
