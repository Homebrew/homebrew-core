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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "2707eaadad1873f87ee5f9daf71f7710aee3be3ca4116768c2f1514f59704d65"
    sha256 cellar: :any,                 arm64_sonoma:  "3006f0623486121db7991757fa52fc933f285aa0d98439ffe75a053dc4c7dcc7"
    sha256 cellar: :any,                 arm64_ventura: "eb53602f7be7e1ba9d42c2a1dcb3f70e926a85007d1338dceebb43b81f65598c"
    sha256 cellar: :any,                 sonoma:        "40cbf3faab35cbab0f7b832df080aa47f972131042eb0be3ec5fc6ac44d5f4ab"
    sha256 cellar: :any,                 ventura:       "2d2f7f630d32e895bf745396161bdfbb24b6cca7d0bf9e9528f461376c19ddfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e068612edda67b9d8024855a41b7133e4af0003173e741f80e2f45abdaaab7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0677ecaba9460fa437cc99fe78a048ec2acceb109f9ccc6e414bcb5ded94cdac"
  end

  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.13"

  conflicts_with "drill", because: "both install a `drill` binary"

  # build patch to work with swig 4.3.0, upstream pr ref, https://github.com/NLnetLabs/ldns/pull/257
  patch do
    url "https://github.com/NLnetLabs/ldns/commit/49b2e4a938d263bb8c532e64f33690551e43ca0c.patch?full_index=1"
    sha256 "e7dd20b06cf1b0728d0822118a8ae231405579a9f35b0d66ac6422249c2be518"
  end

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
