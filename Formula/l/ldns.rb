class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.8.3.tar.gz"
  sha256 "c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860"
  license "BSD-3-Clause"
  revision 1

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "5a0d64836a94921e9bcb63fb6e6477784f479571c51d221b1572a40de9e00498"
    sha256 cellar: :any,                 arm64_ventura:  "ce8189cd452571aea8d3a5d2f15f715c707807471071600fe78246c10ef4cc41"
    sha256 cellar: :any,                 arm64_monterey: "b7c0d00545d1f15b307f6c78ffba724989d7f799aad71d7f336437a7e8954d84"
    sha256 cellar: :any,                 sonoma:         "e50234b63ec0068ecbbaa9a7f1976cbafd83a9ab0774b1889d3c5b5eeb653953"
    sha256 cellar: :any,                 ventura:        "c733862096dc3e1baefde2eef0b40e18c59e0b381d6d98f5722148ccc3fc4436"
    sha256 cellar: :any,                 monterey:       "c0f2ad78dc5131aa0c0fe7afd2630d00f295ee639749b8d0482d1621a6ec24b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ce187a921a1143e42be0f75b28c5690645a10e3d76c423899bd2755e7b5d1da"
  end

  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.12"

  conflicts_with "drill", because: "both install a `drill` binary"

  # build patch to work with swig 4.2.0, upstream pr ref, https://github.com/NLnetLabs/ldns/pull/231
  patch do
    url "https://github.com/NLnetLabs/ldns/commit/40a946995c0b8e4efebdc51dc88e320ce72b104f.patch?full_index=1"
    sha256 "b0556d9e24784fd37ecf0d0e8ab51265e8c8e2e1847692453a4b9f6ad80bdd3b"
  end

  def install
    python3 = "python3.12"
    args = *std_configure_args + %W[
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-pyldns
      PYTHON_SITE_PKG=#{prefix/Language::Python.site_packages(python3)}
      --disable-dane-verify
      --without-xcode-sdk
    ]

    # Fixes: ./contrib/python/ldns_wrapper.c:2746:10: fatal error: 'ldns.h' file not found
    inreplace "contrib/python/ldns.i", "#include \"ldns.h\"", "#include <ldns/ldns.h>"

    ENV["PYTHON"] = which(python3)
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

    system "#{bin}/ldns-key2ds", "powerdns.com.dnskey"

    match = "d4c3d5552b8679faeebc317e5f048b614b2e5f607dc57f1553182d49ab2179f7"
    assert_match match, File.read("Kpowerdns.com.+008+44030.ds")
  end
end
