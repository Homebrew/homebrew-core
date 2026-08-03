class Celt < Formula
  desc "Ultra-low delay audio codec"
  homepage "https://www.celt-codec.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/celt/celt-0.11.3.tar.gz"
  mirror "https://gitlab.xiph.org/xiph/celt/-/archive/v0.11.3/celt-v0.11.3.tar.gz"
  sha256 "7e64815d4a8a009d0280ecd235ebd917da3abdcfd8f7d0812218c085f9480836"
  license "BSD-2-Clause"
  head "https://gitlab.xiph.org/xiph/celt.git", branch: "master"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/celt/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)celt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libogg"

  def install
    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, buildpath/fn
    end

    system "./configure", "--enable-assertions",
                          "--enable-custom-modes",
                          "--enable-float-approx",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <celt/celt.h>

      int main(void)
      {
        int err;

        CELTMode *mode = celt_mode_create(48000, 960, &err);
        if (!mode) return 1;

        celt_mode_destroy(mode);
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-L#{lib}",
                   "-lcelt0",
                   "-o", "test"
    system "./test"
  end
end
