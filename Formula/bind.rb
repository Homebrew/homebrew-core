class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.16.21/bind-9.16.21.tar.xz"
  sha256 "65da5fd4fb80b7d0d7452876f81fd6d67cdcee54a5e3c1d65610334665dfa815"
  license "MPL-2.0"
  revision 1
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "7653fae0990ddf9225baef12a043bebc18226cdb1ef73136593020fb694f0050"
    sha256 big_sur:       "70859324c730fb9114b569b37df237001beb08ddf1b0f943074d8040e4565660"
    sha256 catalina:      "11f9e0255b8070d5d8f0818263633fbcd286054b3094c026801d39837fb35e91"
    sha256 mojave:        "18b6d35257a55b0d107f74a617a03f172d0d519e30ad92725bdcfa2d50d288f1"
    sha256 x86_64_linux:  "f4d4839865ce2ddfedbb3d8247b4c20889fe1fe417f25e28e99e8a5e88578df0"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    vendor_site_packages = libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Fix "configure: error: xml2-config returns badness"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--with-json-c",
      "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
      "--with-libjson=#{Formula["json-c"].opt_prefix}",
      "--with-python-install-dir=#{vendor_site_packages}",
      "--with-python=#{Formula["python@3.10"].opt_bin}/python3",
      "--without-lmdb",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
    ]
    args << "--disable-linux-caps" if OS.linux?
    system "./configure", *args

    system "make"
    system "make", "install"

    (buildpath/"named.conf").write named_conf
    system "#{sbin}/rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"
  end

  def post_install
    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"named", "-f", "-L", var/"log/named/named.log"]
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end
