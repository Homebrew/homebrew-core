class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.16.24/bind-9.16.24.tar.xz"
  sha256 "5582f3734bd6232284f93f14206b8a46d1f819dea4797ae157066f6963b08507"
  license "MPL-2.0"
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git", branch: "main"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "22638377ac6447aeb514e847af603b666a4e4e4c497e56e4a3f6da942e25613a"
    sha256 arm64_big_sur:  "35e21939e97396585a53df0d6d8e378149256c5ac267afc3a58947f1eff3fbf6"
    sha256 monterey:       "7690d9647fe222253d69e235f99eba877311419f1f8ad4097365175091f97665"
    sha256 big_sur:        "fa3ab286974188c2539646cd13e9408302eb5ece8918aaf3264c989618278f42"
    sha256 catalina:       "e1cb285a18c2e0feb4d4280966b75751574b402384c9bb2e1e299849760c7a70"
    sha256 x86_64_linux:   "611a17a95d0273824aa3c9ce87dd5eed13544c6da7c1ce3abfe4c6f5cbf6dc85"
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
