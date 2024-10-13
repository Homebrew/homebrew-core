class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.8.4.tar.gz"
  sha256 "838b907594baaff1cd767e95466a7745998ae64bc74be038dccc62e2de2e4247"
  license "BSD-3-Clause"

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e41ddef970a42de70fcfe79435f15862e391b78380b27e4b3b1d383509df6c4b"
    sha256 cellar: :any,                 arm64_sonoma:  "8a37413be9cdcac1aa759799854adb6228ab6b536080437c44be0bea5e19e340"
    sha256 cellar: :any,                 arm64_ventura: "1982bf6d463f906656151e0c815c8ebdbeae2754c8d31c6176619d0788a4ed03"
    sha256 cellar: :any,                 sonoma:        "e3e22b8607518dd64f222619e49714ebfa7d4d03c6810f43dea8153ead2d1372"
    sha256 cellar: :any,                 ventura:       "f13681ca699403540adc4c598880a572d1b69d969d3a88952d6a02aa2c5d66ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22400444cfcbb07362c0148c795d1c6c7de58c65aaf5ec3978849bd30cb96a88"
  end

  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.13"

  conflicts_with "drill", because: "both install a `drill` binary"

  def python3
    "python3.13"
  end

  def install
    args = %W[
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-pyldns
      PYTHON_PLATFORM_SITE_PKG=#{prefix/Language::Python.site_packages(python3)}
      top_builddir=#{buildpath}
      --disable-dane-verify
      --without-xcode-sdk
    ]

    # Fixes: ./contrib/python/ldns_wrapper.c:2746:10: fatal error: 'ldns.h' file not found
    inreplace "contrib/python/ldns.i", "#include \"ldns.h\"", "#include <ldns/ldns.h>"

    ENV["PYTHON"] = which(python3)

    # Exclude unrecognized options
    args += std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args

    if OS.mac?
      # FIXME: Turn this into a proper patch and send it upstream.
      inreplace "Makefile" do |s|
        s.change_make_var! "PYTHON_LIBS", "-undefined dynamic_lookup"
        s.gsub!(/(\$\(PYTHON_CFLAGS\).*) -no-undefined/, "\\1")
      end
    end

    system "make"
    system "make", "install"
    system "make", "install-pyldns"
    (lib/"pkgconfig").install "packaging/libldns.pc"
  end

  test do
    l1 = <<~EOS
      AwEAAbQOlJUPNWM8DQown5y/wFgDVt7jskfEQcd4pbLV/1osuBfBNDZX
      qnLI+iLb3OMLQTizjdscdHPoW98wk5931pJkyf2qMDRjRB4c5d81sfoZ
      Od6D7Rrx
    EOS
    l2 = <<~EOS
      AwEAAb/+pXOZWYQ8mv9WM5dFva8WU9jcIUdDuEjldbyfnkQ/xlrJC5zA
      EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vpNfIRTFadqsmuU9F
      ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04C
      x83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE
      1LpnJI/wcUpRUiuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW
      UbULpRa/il+Cr5Taj988HqX9Xdm6FjcP4Lbuds/44U7U8du224Q8jTrZ
      57Yvj4VDQKc=
    EOS
    (testpath/"powerdns.com.dnskey").write <<~EOS
      powerdns.com.   10773 IN  DNSKEY  256 3 8  #{l1.tr!("\n", " ")}
      powerdns.com.   10773 IN  DNSKEY  257 3 8  #{l2.tr!("\n", " ")}
    EOS

    system bin/"ldns-key2ds", "powerdns.com.dnskey"

    match = "d4c3d5552b8679faeebc317e5f048b614b2e5f607dc57f1553182d49ab2179f7"
    assert_match match, File.read("Kpowerdns.com.+008+44030.ds")
  end
end
