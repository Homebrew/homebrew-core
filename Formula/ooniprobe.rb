class Ooniprobe < Formula
  include Language::Python::Virtualenv

  desc "Network interference detection tool"
  homepage "https://ooni.torproject.org/"
  url "https://pypi.python.org/packages/ea/31/f6ffff21b406b5c38b78f00b38897a48baae30eef0469089fb1330d86218/ooniprobe-2.1.0.tar.gz"
  sha256 "867f51fcee8d84f68c42dea24c3384736a1e0cf153e1f18254e91682ca6e927a"
  revision 1

  bottle do
    sha256 "34507888fb4b35fc8f4bbe16ee9a62a4572bd4d1142db5504898ac249e1a2edd" => :sierra
    sha256 "bfa8df9cf4c8e45a5067e4b6fc267a70a6c606ab61e23a59b1a0790599fc8444" => :el_capitan
    sha256 "5e29f0944867492446a9f1557d331f35a150a1e69e3a134557dd1b4886b85527" => :yosemite
  end

  depends_on "geoip"
  depends_on "libdnet"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "tor"
  depends_on :python

  # these 4 need to come first or else cryptography will let setuptools
  # easy_install them (which is bad)
  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end
  # end "these 4"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/ce/39/17e90c2efacc4060915f7d1f9b8d2a5b20e54e46233bdf3092e68193407d/asn1crypto-0.21.1.tar.gz"
    sha256 "4e6d7b22814d680114a439faafeccb9402a78095fb23bf0b25f9404c6938a017"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/01/b0/3ac73bf6df716a38568a16f6a9cbc46cc9e8ed6fe30c8768260030db55d4/attrs-16.3.0.tar.gz"
    sha256 "80203177723e36f3bbe15aa8553da6e80d47bfe53647220ccaa9ad7a5e473ccc"
  end

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/73/5a/e5dc9a87e5795ba164e012f2b1cd659e31b722355b79e934e0af892d0493/Automat-0.5.0.tar.gz"
    sha256 "4889ec6763377432ec4db265ad552bbe956768ea3fff39014855308ba79dd7c2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b6/fa/ca682d5ace0700008d246664e50db8d095d23750bb212c0086305450c276/certifi-2017.1.23.tar.gz"
    sha256 "81877fb7ac126e9215dfb15bfef7115fdc30e798e0013065158eed0707fd99ce"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/da/b0/32233c9e84b0d44b39015fba8fec03e88053723c1b455925081dc6ccd9e7/incremental-16.10.1.tar.gz"
    sha256 "14ad6b720ec47aad6c9caa83e47db1843e2b9b98742da5dda08e16a99f400342"
  end

  resource "ipaddr" do
    url "https://files.pythonhosted.org/packages/08/80/7539938aca4901864b7767a23eb6861fac18ef5219b60257fc938dae3568/ipaddr-2.1.11.tar.gz"
    sha256 "1b555b8a8800134fdafe32b7d0cb52f5bdbfdd093707c3dd484c5ea59f1d98b7"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "klein" do
    url "https://files.pythonhosted.org/packages/ff/95/3104e55ea9128d3fefe14ea5dbcd73ccfe21708b99defaaadc1e87f41a4a/klein-17.2.0.tar.gz"
    sha256 "1b5b27899bb694a741063f79cd8de27a1fdcfa1d021d47a583bbee119d2f4fbc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "Parsley" do
    url "https://files.pythonhosted.org/packages/06/52/cac2f9e78c26cff8bb518bdb4f2b5a0c7058dec7a62087ed48fe87478ef0/Parsley-1.3.tar.gz"
    sha256 "9444278d47161d5f2be76a767809a3cbe6db4db822f46a4fd7481d4057208d41"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/60/32/7703bccdba05998e4ff04db5038a6695a93bedc45dcf491724b85b5db76a/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pypcap" do
    url "https://files.pythonhosted.org/packages/83/25/dab6b3fda95a5699503c91bf722abf9d9a5c960a4480208e4bad8747dd0c/pypcap-1.1.5.tar.gz"
    sha256 "4b60d331e83c5bff3e25c7d99e902ea0910027fe9ce7986f0eecf5e0af6e8274"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/ac/14/c792a14b9f8bc4bb9c74c0594c167a2da36e31964098d9e27202142cbd7d/scapy-2.3.3.tgz"
    sha256 "9d3b0293dcdc2cc42eedacbc9003038109558c4b5c5e4a3fa01b8ef5762f1eb0"
  end

  resource "service_identity" do
    url "https://files.pythonhosted.org/packages/f3/2a/7c04e7ab74f9f2be026745a9ffa81fd9d56139fa6f5f4b4c8a8c07b2bfba/service_identity-16.0.0.tar.gz"
    sha256 "0630e222f59f91f3db498be46b1d879ff220955d7bbad719a5cb9ad14e3c3036"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/d2/5d/ed5071740be94da625535f4333793d6fd238f9012f0fee189d0c5d00bd74/Twisted-17.1.0.tar.bz2"
    sha256 "dbf211d70afe5b4442e3933ff01859533eba9f13d8b3e2e1b97dc2125e2d44dc"
  end

  resource "txsocksx" do
    url "https://files.pythonhosted.org/packages/ed/36/5bc796eb2612b500baa26a68481d699e08af5382152a9de18e5a45b44ea7/txsocksx-1.15.0.2.tar.gz"
    sha256 "4f79b5225ce29709bfcee45e6f726e65b70fd6f1399d1898e54303dbd6f8065f"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/03/23/4453ab8728c84963cf293d5180b9f529bb10bf8285031c4681e2621b175f/txtorcon-0.18.0.tar.gz"
    sha256 "12be80f1d5e2893378c6e8c752cf159479f868f8424e16b34b75cd679a0ab171"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/13/a2/c4f2a1e1e9239cd979de00a2d7e0008559c46d920e9842e9b8063c5e6bf5/Werkzeug-0.12.tar.gz"
    sha256 "f007848ed997101cb5c09a47e46c0b0b6f193d0f8a01cd2af920d77bf1ab4e68"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/44/af/cea1e18bc0d3be0e0824762d3236f0e61088eeed75287e7b854d65ec9916/zope.interface-4.3.3.tar.gz"
    sha256 "8780ef68ca8c3fe1abb30c058a59015129d6e04a6b02c2e56b9c7de6078dfa88"
  end

  def install
    # provided by libdnet
    inreplace "requirements.txt", "pydumbnet", ""

    # force a distutils install
    inreplace "setup.py", "def run(", "def norun("

    # obey the settings.ini we write
    inreplace "ooni/settings.py", /(IS_VIRTUALENV = ).*/, "\\1 False"

    (buildpath/"ooni/settings.ini").atomic_write <<-EOS.undent
      [directories]
      usr_share = #{pkgshare}
      var_lib = #{var}/lib/ooni
      etc = #{etc}/ooni
    EOS

    virtualenv_install_with_resources

    man1.install Dir["data/*.1"]
    pkgshare.install Dir["data/*"]
  end

  def post_install
    return if (pkgshare/"decks-available").exist?
    ln_s pkgshare/"decks", pkgshare/"decks-available"
    ln_s pkgshare/"decks/web.yaml", pkgshare/"current.deck"
  end

  def caveats; <<-EOS.undent
    Decks are installed to #{opt_pkgshare}/decks.
    EOS
  end

  plist_options :startup => "true", :manual => "ooniprobe -i #{HOMEBREW_PREFIX}/share/ooniprobe/current.deck"

  def plist; <<-EOS.undent
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>Label</key>
       <string>#{plist_name}</string>
     <key>EnvironmentVariables</key>
     <dict>
       <key>PATH</key>
       <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
     </dict>
     <key>ProgramArguments</key>
     <array>
       <string>#{opt_bin}/ooniprobe-agent</string>
       <string>run</string>
     </array>
     <key>RunAtLoad</key>
       <true/>
     <key>KeepAlive</key>
       <true/>
     <key>StandardErrorPath</key>
       <string>/dev/null</string>
     <key>StandardOutPath</key>
       <string>/dev/null</string>
     <key>WorkingDirectory</key>
       <string>#{opt_prefix}</string>
   </dict>
   </plist>
   EOS
  end

  test do
    (testpath/"ooni/var_lib").mkpath
    (testpath/"ooni/etc").mkpath

    (testpath/"ooni/settings.ini").atomic_write <<-EOS.undent
      [directories]
      usr_share = #{pkgshare}
      var_lib = #{testpath}/ooni/var_lib
      etc = #{testpath}/ooni/etc
    EOS
    touch testpath/"ooni/var_lib/initialized"

    (testpath/"ooni/hosts.txt").write "github.com:443\n"
    ENV["OONIPROBE_SETTINGS"] = "#{testpath}/ooni/settings.ini"
    system bin/"ooniprobe", "-ng", "blocking/tcp_connect", "-f", testpath/"ooni/hosts.txt"
  end
end
