class Gengetopt < Formula
  desc "Generate C code to parse command-line arguments via getopt_long"
  homepage "https://www.gnu.org/software/gengetopt/"
  url "https://ftpmirror.gnu.org/gnu/gengetopt/gengetopt-2.23.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.23.tar.xz"
  sha256 "b941aec9011864978dd7fdeb052b1943535824169d2aa2b0e7eae9ab807584ac"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f37f85a3ddffa7c215b078fc05f2980490d18d0202e6a92bcffd5ab88b2c9121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "91c1d9533d5738baeeff859785ad663d51bb280ba1744f78183efa442b4bc37c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4ee83de15c84dbd2f8d6759d09e6dade6b25cbcdea6d7399bf5713e02f9cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c731183d0fbdec83471189c83b19f7f3617daeabc4845baf8c0243e221d95f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0187835bf0f0b221a2b1bb2bcc454aede83fe8cd15e74ea4bca09c7b7feccb29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d869a2ffa87824b4e5854df92e2f60f652fe4e5e20d188207bf6171d7d18f84"
    sha256 cellar: :any_skip_relocation, sonoma:         "22d37123ae7d0c95c2eedc1beac9d713ba4bd9f97c37d2211b2c13c30d91a2de"
    sha256 cellar: :any_skip_relocation, ventura:        "8ca8065df65ce3ea45a4335c7c856f3f5718215e1adb5719e06eba9de3c6e80a"
    sha256 cellar: :any_skip_relocation, monterey:       "90b1ee25cdf823bad41c76f92afabe8a1b7a8db6f29b4cc533c6914d833d992f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f57ffafddb271d729ec0c07bdc564fc1bf0a52ee9b060cde1c5c8da3dbe3f515"
    sha256 cellar: :any_skip_relocation, catalina:       "7134042a80bb314db08216b1de2d293b5925ab729ba87649fdab4dc6298256f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "44cfbe8a7d55d574a917f8f35264ecf1f4798c3686c8288750ea971b66a0d9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379c0b354e21a5da13e62c6dbce3edfc1580561fb59015f015769c18cc804a60"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ggo = <<~EOS
      package "homebrew"
      version "0.9.5"
      purpose "The missing package manager for macOS"

      option "verbose" v "be verbose"
    EOS

    pipe_output("#{bin}/gengetopt --file-name=test", ggo, 0)
    assert_path_exists testpath/"test.h"
    assert_path_exists testpath/"test.c"
    assert_match(/verbose_given/, File.read("test.h"))
  end
end
