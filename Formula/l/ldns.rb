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
    sha256 cellar: :any,                 arm64_sonoma:   "bb1cce7cdda917f639aa145653f49ef3eaaefdf229ba8e614308f11aec213e57"
    sha256 cellar: :any,                 arm64_ventura:  "91cefcb3326fd36c21f26f0f905543bb75626ef382eda949c892a8bd8ebfb659"
    sha256 cellar: :any,                 arm64_monterey: "1bf12612f2a1fa6837f4360c3965f0cb568c920f28ce3e5c2d783e31ff480800"
    sha256 cellar: :any,                 arm64_big_sur:  "9fde4555b1801467eb72663a602b265e423fa85d12fd5ad878fc242852e08e60"
    sha256 cellar: :any,                 sonoma:         "1fe598eaaf5e27cbedb1c15756b9e8f9879c0a3401c3c6d9faf292cf3b75a0ce"
    sha256 cellar: :any,                 ventura:        "08d75bc74a4667defb24c4ed92bd13da55317e836592c2e5851ea7132424551f"
    sha256 cellar: :any,                 monterey:       "a6443e00af46421f902df8ce0e4cebb6d01a48d4532275d5321e4fa547b41c3f"
    sha256 cellar: :any,                 big_sur:        "74adc13f57040a1f3ee99f147e57f457abc54b9c3c68071cc0f6e4f4784419cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6401729572e7c28d1d691e47a8bbcd7cfb88b9e1a2e1a2df0e6a3ec066286ff"
  end

  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.11"

  conflicts_with "drill", because: "both install a `drill` binary"

  def install
    python3 = "python3.11"
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
