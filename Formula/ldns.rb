class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.8.3.tar.gz"
  sha256 "c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860"
  license "BSD-3-Clause"

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "84fa570a26a953f4a793d8498c95fd4d2e63646673e514566b43096e6d01944b"
    sha256 cellar: :any,                 arm64_big_sur:  "c165e0faa3f490a9f7c7baebb538cf79b48c1334fa4ea6da3a19ca0401b36bef"
    sha256 cellar: :any,                 monterey:       "424b3710704a509032718b9e82c3814c7eeb3391b7ac4cc8fd2ce7e7fda8946d"
    sha256 cellar: :any,                 big_sur:        "2187a1082edbca32be2bf59a8222f05c6fb68c371324116d288547c5cca60ce3"
    sha256 cellar: :any,                 catalina:       "5e9493ff659d9b2e8587494f94df59bb7f97897dca0292c1880d4ebe9cef28e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82fc8ab9aa3917ad9e3d565271a6e32231eb3aa914445002f4b52053e640455"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  conflicts_with "drill", because: "both install a `drill` binary"

  def install
    python3 = "python3.10"
    args = %W[
      --prefix=#{prefix}
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
