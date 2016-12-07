class Ooniprobe < Formula
  include Language::Python::Virtualenv

  desc "Network interference detection tool"
  homepage "https://ooni.torproject.org/"
  url "https://pypi.python.org/packages/ea/31/f6ffff21b406b5c38b78f00b38897a48baae30eef0469089fb1330d86218/ooniprobe-2.1.0.tar.gz"
  sha256 "867f51fcee8d84f68c42dea24c3384736a1e0cf153e1f18254e91682ca6e927a"

  bottle do
    sha256 "ab5aa52408ae04f8b8e546efe1cc0516c75ec1ca78a5199f996fe3822fe4acdb" => :sierra
    sha256 "04c6c488811904d5f627f3bd0a4dd9879c863d3f167ab0c412a52f9c428c15b1" => :el_capitan
    sha256 "16b41cc859c7107c25f0976a13156eb59acf89cfe4642ad8c016a7a8364d8bcf" => :yosemite
  end

  depends_on "geoip"
  depends_on "libdnet"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "tor"
  depends_on :python

  # these 4 need to come first or else cryptography will let setuptools
  # easy_install them (which is bad)
  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end
  # end "these 4"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/71/1682316894ed80b362b9102e7a10997136d8dc1213c36a9f0515c451373a/attrs-16.2.0.tar.gz"
    sha256 "136f2ec0f94ec77ff2990830feee965d608cab1e8922370e3abdded383d52001"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6c/c5/7fc1f8384443abd2d71631ead026eb59863a58cad0149b94b89f08c8002f/cryptography-1.5.3.tar.gz"
    sha256 "cf82ddac919b587f5e44247579b433224cc2e03332d2ea4d89aa70d7e6b64ae5"
  end

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
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
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "klein" do
    url "https://files.pythonhosted.org/packages/32/ab/5aae3b335fef4ce04595c67b74280b54b18fdd85ffd653bc6f7ae61b35b1/klein-15.3.1.tar.gz"
    sha256 "e90f2d9d3fe3a37be35821c886d8eb35d0cb5e4bd6d798513215b260adbe82c2"
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
    url "https://files.pythonhosted.org/packages/ee/50/224854b4730f4daa941b8bcc4834a15bfee3012dad663fa760a89210df2c/Twisted-16.5.0.tar.bz2"
    sha256 "0207d88807482fa670a84926590e163a2a081a29745de34c5a6dc21066abae73"
  end

  resource "txsocksx" do
    url "https://files.pythonhosted.org/packages/ed/36/5bc796eb2612b500baa26a68481d699e08af5382152a9de18e5a45b44ea7/txsocksx-1.15.0.2.tar.gz"
    sha256 "4f79b5225ce29709bfcee45e6f726e65b70fd6f1399d1898e54303dbd6f8065f"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/42/fc/de34ee8bc9620498272cba765e8b8eeabffcc346aa83f8d0d441616d5dd6/txtorcon-0.17.0.tar.gz"
    sha256 "5e321387ab56f22d184b18d91a60c30dd1f72575d9e32ff3614ef911bce49daa"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/43/2e/d822b4a4216804519ace92e0368dcfc4b0b2887462d852fdd476b253ecc9/Werkzeug-0.11.11.tar.gz"
    sha256 "e72c46bc14405cba7a26bd2ce28df734471bc9016bc8b4cb69466c2c14c2f7e5"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/1b/d55c39f2cf442bd9fb2c59760ed058c84b57d25c680819c25f3aff741e1f/zope.interface-4.3.2.tar.gz"
    sha256 "6a0e224a052e3ce27b3a7b1300a24747513f7a507217fcc2a4cb02eb92945cee"
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
    Decks are installed to #{opt_prefix}/share/ooniprobe/decks.
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
     <key>WorkingDirectory</key>
       <string>#{var}/log/</string>
   </dict>
   </plist>
   EOS
  end

  test do
    mkdir_p "#{testpath}/ooni/var_lib"
    mkdir_p "#{testpath}/ooni/etc"

    (testpath/"ooni/settings.ini").atomic_write <<-EOS.undent
      [directories]
      usr_share = #{pkgshare}
      var_lib = #{testpath}/ooni/var_lib
      etc = #{testpath}/ooni/etc
    EOS
    (testpath/"ooni/var_lib/initialized").write ""

    (testpath/"ooni/hosts.txt").write "github.com:443\n"
    ENV["OONIPROBE_SETTINGS"] = "#{testpath}/ooni/settings.ini"
    system bin/"ooniprobe", "-ng", "blocking/tcp_connect", "-f", testpath/"ooni/hosts.txt"
  end
end
