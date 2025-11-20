class Ldns < Formula
  desc "DNS library written in C"
  homepage "https://nlnetlabs.nl/projects/ldns/"
  url "https://nlnetlabs.nl/downloads/ldns/ldns-1.8.4.tar.gz"
  sha256 "838b907594baaff1cd767e95466a7745998ae64bc74be038dccc62e2de2e4247"
  license "BSD-3-Clause"
  revision 1

  # https://nlnetlabs.nl/downloads/ldns/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/ldns.git"
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2002e705ab0503ef65d8f9f1f810bf7a3973790ebbc20154c74c547ecf4e3fad"
    sha256 cellar: :any,                 arm64_sequoia: "cafc56249b3b8f7f226b2890df163b76b692b8a541a12d2ee37aebbd7b2b48d1"
    sha256 cellar: :any,                 arm64_sonoma:  "cc39729a2c4ba4a2a171539338ad298b8bf6a2a8a48a42a0515f71ed1f47ae72"
    sha256 cellar: :any,                 sonoma:        "babaa19154f91c1256b486dca3ba2e3fe390adc73bad62ce68353110bd695acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01ef4425bae969379c2466ecfc3bca21436cc69b7e21298342d098b82a6dd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a6aff98a9036107f56b657a605fa5b3b73cdfd673b86fe0daf69f063ff5787"
  end

  depends_on "swig" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "drill", because: "both install a `drill` binary"

  # build patch to work with swig 4.3.0, upstream pr ref, https://github.com/NLnetLabs/ldns/pull/257
  patch do
    url "https://github.com/NLnetLabs/ldns/commit/49b2e4a938d263bb8c532e64f33690551e43ca0c.patch?full_index=1"
    sha256 "e7dd20b06cf1b0728d0822118a8ae231405579a9f35b0d66ac6422249c2be518"
  end

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
