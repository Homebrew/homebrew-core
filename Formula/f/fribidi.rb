class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.14/fribidi-1.0.14.tar.xz"
  sha256 "76ae204a7027652ac3981b9fa5817c083ba23114340284c58e756b259cd2259a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5aea13f26a125562f2564cfc3c4051bd3bd6c65780b8349f5bbca3afbc3f2bf5"
    sha256 cellar: :any,                 arm64_ventura:  "e4bfebfee694b26afb1a95460a627eea98c762d1cab9b2d759c9206a3d008fb3"
    sha256 cellar: :any,                 arm64_monterey: "04f12760ee7c9e0a000d2d58985b57b2984378fee41c09174324fe47b88e81d1"
    sha256 cellar: :any,                 sonoma:         "4e5ad7bbd7039debb0f7a2b8ab8774e4652e698aa7d28a71ce62667c529c7c27"
    sha256 cellar: :any,                 ventura:        "c8b57d7acc7618677023c3849095b7f89e6440b747ae589704d30a607e0c6d56"
    sha256 cellar: :any,                 monterey:       "2f9cdc1f4b36b0fbc823aa4346775e739947033b9915ae59e7fb87c9ba0fbb58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ff015a79f1a78045a857c867794697ed48fbab97ae36ad785c62049074210d5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
