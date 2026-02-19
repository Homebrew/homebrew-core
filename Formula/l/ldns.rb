class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.9.0.tar.gz"
  sha256 "abaeed2858fbea84a4eb9833e19e7d23380cc0f3d9b6548b962be42276ffdcb3"
  license "BSD-3-Clause"

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "629f7a51a1a2803dd5416db7237b7c640e72b04614f2012df5fe08cd9639636f"
    sha256 cellar: :any,                 arm64_sequoia: "714d554e3c767062e77498ba92c0ff91b0871d86197ad91f90da65d9db3ab254"
    sha256 cellar: :any,                 arm64_sonoma:  "81f4fd69ea66890b1b1db8122b5da93744270950657363ba40c32dec57b0df80"
    sha256 cellar: :any,                 sonoma:        "190aaba1359ad4d26285d31902e53da00ee506610528baafdc1fbf539fb4f9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee79e560ef1f4d78924cf2070eb8dadca89a504f0f5417a99d3bd3730589d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad62627c746df971912e4cafba581db58e81f0bd90cb93bba6292213467237f"
  end

  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "drill", because: "both install a `drill` binary"

  def python3
    "python3.14"
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
