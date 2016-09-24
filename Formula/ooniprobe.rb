class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.torproject.org/"
  url "https://pypi.python.org/packages/b4/6f/41d2e88cb59cfcbd501a00debf6fbc30d152f928d7e69da41ddfcf369870/ooniprobe-1.6.0.tar.gz"
  sha256 "6ec8e5d3cf19b286b6863e2d19dac4244526db9757effde3b6cfda5f725da170"

  bottle do
    cellar :any
    sha256 "92acbfb671dd47724e42134a1bb6c5421cdaaf2f71482a6a10c9db87f9cabd1e" => :el_capitan
    sha256 "92d3efdacab3b896df7fa565372e3dd6832af7225d843ef662e0b601ff5fa620" => :yosemite
    sha256 "e7e76ecbdfae71dfaf0f2e2dc7207a6d53953350074be242c801275c0272b01f" => :mavericks
  end

  depends_on "geoip"
  depends_on "libdnet"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "tor"
  depends_on :python if MacOS.version <= :snow_leopard

  # these 4 need to come first or else cryptography will let setuptools
  # easy_install them (which is bad)
  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end
  # end "these 4"

  resource "characteristic" do
    url "https://pypi.python.org/packages/source/c/characteristic/characteristic-14.3.0.tar.gz"
    sha256 "ded68d4e424115ed44e5c83c2a901a0b6157a959079d7591d92106ffd3ada380"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "GeoIP" do
    url "https://pypi.python.org/packages/source/G/GeoIP/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.14.tar.gz"
    sha256 "226f4be44c6cb64055e23060848266f51f329813baae28b53dc50e93488b3b3e"
  end

  resource "ipaddr" do
    url "https://pypi.python.org/packages/source/i/ipaddr/ipaddr-2.1.11.tar.gz"
    sha256 "1b555b8a8800134fdafe32b7d0cb52f5bdbfdd093707c3dd484c5ea59f1d98b7"
  end

  resource "Parsley" do
    url "https://pypi.python.org/packages/source/P/Parsley/Parsley-1.2.tar.gz"
    sha256 "50d30cee70770fd44db7cea421cb2fb75af247c3a1cd54885c06b30a7c85dd23"
  end

  resource "pyasn1-modules" do
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.7.tar.gz"
    sha256 "794dbcef4b7124b8271f12eb7eea0d37b466012f11ce023f91e2e2082df11c7e"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pypcap" do
    url "https://pypi.python.org/packages/source/p/pypcap/pypcap-1.1.1.tar.gz"
    sha256 "b310d5af36f5d68ef4217fda68086ffce56345b415eaac15ad618f94057b017b"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "scapy" do
    url "https://pypi.python.org/packages/6d/72/c055abd32bcd4ee6b36ef8e9ceccc2e242dea9b6c58fdcf2e8fd005f7650/scapy-2.3.2.tar.gz"
    sha256 "a9059ced6e1ded0565527c212f6ae4c735f4245d0f5f2d7313c4a6049b005cd8"
  end

  resource "service_identity" do
    url "https://pypi.python.org/packages/source/s/service_identity/service_identity-14.0.0.tar.gz"
    sha256 "3105a319a7c558490666694f599be0c377ad54824eefb404cde4ce49e74a4f5a"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "Twisted" do
    url "https://pypi.python.org/packages/18/85/eb7af503356e933061bf1220033c3a85bad0dbc5035dfd9a97f1e900dfcb/Twisted-16.2.0.tar.bz2"
    sha256 "a090e8dc675e97fb20c3bb5f8114ae94169f4e29fd3b3cbede35705fd3cdbd79"
  end

  resource "txsocksx" do
    url "https://pypi.python.org/packages/source/t/txsocksx/txsocksx-1.15.0.2.tar.gz"
    sha256 "4f79b5225ce29709bfcee45e6f726e65b70fd6f1399d1898e54303dbd6f8065f"
  end

  resource "txtorcon" do
    url "https://pypi.python.org/packages/69/f9/57b6179ba15c111f4926284a16a4486bdc3648508feeb72a93d203eb9b3c/txtorcon-0.14.2.tar.gz"
    sha256 "f99819b1a71b8dea9e80317ec83c990b4ff608c98bc78a9fc1dc9991d349d13f"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.2.tar.gz"
    sha256 "441fefcac1fbac57c55239452557d3598571ab82395198b2565a29d45d1232f6"
  end

  def install
    ENV["PYTHONPATH"] = Formula["libdnet"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # namespace package hint
    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"

    # provided by libdnet
    inreplace "requirements.txt", "pydumbnet", ""

    # force a distutils install
    inreplace "setup.py", "def run(", "def norun("
    (buildpath/"ooni/settings.ini").atomic_write <<-EOS.undent
      [directories]
      usr_share = #{share}/ooni
      var_lib = #{var}/lib/ooni
    EOS

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    man1.install Dir["data/*.1"]
    (share/"ooni").install Dir["data/*"]
  end

  def post_install
    require "open3"

    (var/"lib/ooni").mkpath
    system bin/"ooniresources"
    Open3.popen3("#{bin}/oonideckgen", "-o",
                 "#{HOMEBREW_PREFIX}/share/ooni/decks/") do |_, stdout, _|
      current_deck = stdout.read.split("\n")[-1].split(" ")[-1]
      ln_s current_deck, "#{HOMEBREW_PREFIX}/share/ooni/decks/current.deck"
    end
  end

  def caveats; <<-EOS.undent
    Decks are installed to #{HOMEBREW_PREFIX}/share/ooni/decks/.
    EOS
  end

  plist_options :startup => "true", :manual => "ooniprobe -i #{HOMEBREW_PREFIX}/share/ooni/decks/current.deck"

  def plist; <<-EOS.undent
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>Label</key>
       <string>#{plist_name}</string>
     <key>Program</key>
       <string>#{opt_bin}/ooniprobe</string>
     <key>ProgramArguments</key>
     <array>
       <string>-i</string>
       <string>#{opt_share}/ooni/decks/current.deck</string>
     </array>
     <key>RunAtLoad</key>
       <false/>
     <key>KeepAlive</key>
       <false/>
     <key>StandardErrorPath</key>
       <string>/dev/null</string>
     <key>StandardOutPath</key>
       <string>/dev/null</string>
     <key>StartCalendarInterval</key>
     <dict>
       <key>Hour</key>
       <integer>00</integer>
       <key>Minute</key>
       <integer>00</integer>
     </dict>
   </dict>
   </plist>
   EOS
  end

  test do
    (testpath/"hosts.txt").write "github.com:443\n"
    system bin/"ooniprobe", "blocking/tcp_connect", "-f", testpath/"hosts.txt"
  end
end
