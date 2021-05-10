class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.9.0.tar.gz"
  sha256 "a0b066c11257879c7c85311dea69c67f6dc741ef339db6514f85b64992c40d2a"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://ftpmain.gnustep.org/pub/gnustep/core/"
    regex(/href=.*?gnustep-make[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc1e65ba40d7093f887784411861c2ce6056e3a1bbdfffa9f73c7d6255505129"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b8f96f0d47226cb8f00646acced66850754540352da1b6b682b9a07f80d4b90"
    sha256 cellar: :any_skip_relocation, catalina:      "0112f9b5cc350a2e8efc7eff2ea1b3e0b13e62877ce02592eac34052b33de00f"
    sha256 cellar: :any_skip_relocation, mojave:        "4025644721c7902db42e5f63a1d8980056b809bdab7237289b92381e82492cca"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ff2edab383602c3449f074284f992567b0d072a3a442be898be21da0d484d3c3"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
