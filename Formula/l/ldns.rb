class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.9.2.tar.gz"
  sha256 "b524fa21994b6e834200ceb8c27f1b84bda5982fe35706f058196c079db94d5d"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5be2dfec48a0ef2c5af221172a93e8309149a5c0dcaed215964436c52dc87f7d"
    sha256 cellar: :any, arm64_tahoe:       "03966b363928b66a20db0a6bd5e48f1c5229648709f91f208b5ceaa84b8a43f4"
    sha256 cellar: :any, arm64_sequoia:     "d752514ae2395b210185bcb1159dfbd57d60acf397b66aff1c484fb59aa16246"
    sha256 cellar: :any, arm64_linux:       "d002925575623e03940e6e000bbd307330db894f1b76821ac7078a63a4a74dd7"
    sha256 cellar: :any, x86_64_linux:      "0b389096fc4ddb6d4288b88c22e943365a7f0e82f2ca45c6488cd06403581fce"
  end

  depends_on "swig" => :build
  depends_on "openssl@4"
  depends_on "python@3.14"

  conflicts_with "drill", because: "both install a `drill` binary"

  def install
    args = %W[
      --with-drill
      --with-examples
      --with-ssl=#{formula_opt_prefix("openssl@4")}
      --with-pyldns
      PYTHON_PLATFORM_SITE_PKG=#{prefix/Language::Python.site_packages(python3)}
      top_builddir=#{buildpath}
      --disable-dane-verify
      --without-xcode-sdk
    ]

    # Fixes: ./contrib/python/ldns_wrapper.c:2746:10: fatal error: 'ldns.h' file not found
    inreplace "contrib/python/ldns.i", "#include \"ldns.h\"", "#include <ldns/ldns.h>"

    ENV["PYTHON"] = python3

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
