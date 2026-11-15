class Libklvanc < Formula
  desc "VANC Processing Framework"
  homepage "https://github.com/stoth68000/libklvanc"
  url "https://github.com/stoth68000/libklvanc/archive/refs/tags/vid.obe.1.7.0.tar.gz"
  sha256 "a1c40c61eb34c98cd9023735b5769b7f43f4b34096149647c8bdf4de937e84c3"
  license "LGPL-2.1-or-later"
  head "https://github.com/stoth68000/libklvanc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2cc30e79117f1f1c8f8ef35a9f2cb265a1b9db783b8bd51f013f4b97620775da"
    sha256 cellar: :any, arm64_tahoe:       "3cee6392d6e38a0d0235669ff6f4ebd668931dc2b8180f3ef47e01faee183969"
    sha256 cellar: :any, arm64_sequoia:     "aa6f71bdb7e4204904e28a87c398b9fedae4f9beea9f507ad7539d61c15e06af"
    sha256 cellar: :any, arm64_linux:       "ca68e9866cf1afcc5c54bf595873032074560e85fe969b12fe76be343d7a3882"
    sha256 cellar: :any, x86_64_linux:      "150b312a114140a1ea310a0613aeaa3e22a1523075d500dde4d8f38194059b47"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "./autogen.sh", "--build"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libklvanc/vanc.h>
      int main()
      {
        struct klvanc_context_s *ctx;
        int ret;

        if (klvanc_context_create(&ctx) < 0) return 1;
        klvanc_context_destroy(ctx);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lklvanc"
    system "./test"

    output = shell_output("#{bin}/klvanc_test_api")
    assert_match(/Total:\s+\d+\s+passed,\s+0\s+failed/, output)
  end
end
