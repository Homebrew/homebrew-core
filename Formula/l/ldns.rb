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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "716f3b03d4364ba0f0a395171c145b704f8ad0739e174a5c73a4423e8f7c8d51"
    sha256 cellar: :any,                 arm64_ventura:  "27be30c5d63b1dc9d03c7dee714380ce4f8dfaec2ad3952224b85aa1dba22505"
    sha256 cellar: :any,                 arm64_monterey: "b5af9a98dedc6b4861b8506d516e351fedeb17b4643f1da2feeb5da4392d4426"
    sha256 cellar: :any,                 sonoma:         "60022d90fbf3c4c4c8e33d23eacf14066c5c5d9ec0ca522a5f02c44972f2efb1"
    sha256 cellar: :any,                 ventura:        "7a534bf6bebe3780ef463aeba00aaf9e32becbe880343ef71b5a20f99c8a93c9"
    sha256 cellar: :any,                 monterey:       "64d0687086091f591eceb9a81473016ea26f7aa7f5e94322154159de537d24f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d5164fde8111e360025df90d3bcd0cf0fb8b735fc5c9c5a854504d63ed928c3"
  end

  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.12"

  conflicts_with "drill", because: "both install a `drill` binary"

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
