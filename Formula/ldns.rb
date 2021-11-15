class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.7.1.tar.gz"
  sha256 "8ac84c16bdca60e710eea75782356f3ac3b55680d40e1530d7cea474ac208229"
  license "BSD-3-Clause"
  revision 4

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c465f15a046a754c2bfd1c637201244d1dde5eea60b622ec851915f03123b91c"
    sha256 cellar: :any,                 arm64_big_sur:  "8bd8186ef4b0e89f852828f66a99952bb9a6635dae7090fc6a569b33e3d86667"
    sha256 cellar: :any,                 monterey:       "715d686d4cd96158117854f1aa1850dace62a2a442f5b5a4b701f11c72fcec80"
    sha256 cellar: :any,                 big_sur:        "311ced9ff7f664b64f10939ba335fb3458d7b020e4f293a36a9fa10c92203620"
    sha256 cellar: :any,                 catalina:       "014c23349aa56ea585da062b287e19999ed83609e3b75626cdd4b3ca4cdb9555"
    sha256 cellar: :any,                 mojave:         "8228a7d9fdcb7e6c5210e9b4ce3975a68c36764a6c3025ded8abd2b60bef3c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "886bf69bb1a7215a5e9626ac6cbb04fd52cc4ddd2cdec9769ffc77480099a4d3"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "drill", because: "both install a `drill` binary"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-drill
      --with-examples
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-pyldns
      PYTHON_SITE_PKG=#{lib}/python3.9/site-packages
      --disable-dane-verify
      --without-xcode-sdk
    ]

    # Fixes: ./contrib/python/ldns_wrapper.c:2746:10: fatal error: 'ldns.h' file not found
    inreplace "contrib/python/ldns.i", "#include \"ldns.h\"", "#include <ldns/ldns.h>"

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    system "./configure", *args

    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "PYTHON_LDFLAGS", "-undefined dynamic_lookup"
        s.gsub!(/(\$\(PYTHON_LDFLAGS\).*) -no-undefined/, "\\1")
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
