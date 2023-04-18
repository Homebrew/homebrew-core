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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e0d0acfb1f7f199ce05fe11177adf2db2492911a0f2d51aed693f4127b477604"
    sha256 cellar: :any,                 arm64_monterey: "46ef12897880d4f3d53508ea397362762d6f97c68259ec67041bbd12b35edbbd"
    sha256 cellar: :any,                 arm64_big_sur:  "251b84cfda5e8e24ca2e1dcc8bba380beb7edca524ab09b188fa2c5fbe18fa05"
    sha256 cellar: :any,                 ventura:        "b2c4a095c0c4eb850537697ba51153c285033cb3f597ac4739a7167277ceb5bc"
    sha256 cellar: :any,                 monterey:       "a3185a8decca00ced7e56098d8e6897e3cecf4f6a5db970d8d7dcceb24178c5d"
    sha256 cellar: :any,                 big_sur:        "0faa2e9fc9c0fb46cfa52d539838875ffcec82e886977d0d23d91e111f29efed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6bc1207ee00802b2bd19648ea2da9dae3eee6da0236092c9c398f51b4fa56f1"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  conflicts_with "drill", because: "both install a `drill` binary"

  def install
    python3 = "python3.11"
    args = *std_configure_args + %W[
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
