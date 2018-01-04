class Fdroidserver < Formula
  include Language::Python::Virtualenv

  desc "Create and manage Android app repositories for F-Droid"
  homepage "https://f-droid.org"
  url "https://files.pythonhosted.org/packages/85/c1/0aa30a82716685610aed583decdbc991df95e5ee81d827855c45a99eb597/fdroidserver-1.0.0.tar.gz"
  sha256 "e760524f392e6122d9b938f8811aad087b062fb00140967073574eabc15b1972"

  bottle do
    cellar :any
    sha256 "ced19f5da67910613b852709de6160b68ed2868859f3ceea62a56f7ba8243e58" => :high_sierra
    sha256 "31e626536a90f4e701fbb754243055d39d979fb72b90870fdf82b9de6d4e3682" => :sierra
    sha256 "116ca8590215f5df22911184fbfd356579663f775c20fe59bf95c6378a0745fd" => :el_capitan
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "python3"
  depends_on "s3cmd"
  depends_on "webp"

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1d/a9/3de9cf302166aec7d1ee140a417e0717eca10a69c89bcbe5a243fb8f956c/apache-libcloud-2.2.1.tar.gz"
    sha256 "d065d9da8ba192badad3a98c2f6c3ef9dabba45d1318638b9c1bac83f6c3e7a9"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/95/2e/3c99b8707a397153bc78870eb140c580628d7897276960da25d8a83c4719/docker-pycreds-0.2.1.tar.gz"
    sha256 "93833a2cf280b7d8abbe1b8121530413250c6cd4ffed2c1cf085f335262f7348"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/84/11/22e68bd46fd545b17d0a0b200cf75c20e9e7b817726a69ad5f3070fd0d3c/gitdb2-2.0.3.tar.gz"
    sha256 "b60e29d4533e5e25bb50b7678bbc187c8f6bcff1344b4f293b2ba55c85795f09"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/1c/08/a2b5ba4ad43c4c33066ced2c45958593ab2554bb0d09f7ecb9bf9092e5f6/GitPython-2.1.8.tar.gz"
    sha256 "ad61bc25deadb535b047684d06f3654c001d9415e1971e51c9c20f5b510076e9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "mwclient" do
    url "https://files.pythonhosted.org/packages/cd/38/beaf985032b42a0b0c8f9028b469c4dcb0bd7bfab62707ec27af7e890e84/mwclient-0.8.6.tar.gz"
    sha256 "08f917b995b331b937ed8c7e297406e3c8d33b80234679ee7fbfeeafd7570a8e"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/a5/8a/212e9b47fb54be109f3ff0684165bb38c51117f34e175c379fce5c7df754/oauthlib-2.0.6.tar.gz"
    sha256 "ce57b501e906ff4f614e71c36a3ab9eacbb96d35c24d1970d2539bbc3ec70ce1"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/c8/de/791773d6a4b23327c7475ae3d7ada0d07fa147bf77fb6f561a4a7d8afd11/paramiko-2.4.0.tar.gz"
    sha256 "486f637f0a33a4792e0e567be37426c287efaa8c4c4a45e3216f9ce7fd70b1fc"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/0f/57/25be1a4c2d487942c3ed360f6eee7f41c5b9196a09ca71c54d1a33c968d9/Pillow-5.0.0.tar.gz"
    sha256 "12f29d6c23424f704c66b5b68c02fe0b571504459605cfe36ab8158359b0e1bb"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/ab/76/36ab0e099e6bd27ed95b70c2c86c326d3affa59b9b535c63a2f892ac9f45/pyasn1-modules-0.2.1.tar.gz"
    sha256 "af00ea8f2022b6287dc375b2c70f31ab5af83989fc6fe9eacd4976ce26cd7ccc"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/bb/c6/0a6d22ae1782f261fc4274ea9385b85bf792129d7126575ec2a71d8aea18/python-vagrant-0.5.15.tar.gz"
    sha256 "af9a8a9802d382d45dbea96aa3cfbe77c6e6ad65b3fe7b7c799d41ab988179c6"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/87/16/99038537dc58c87b136779c0e06d46887ff5104eb8c64989aac1ec8cba81/qrcode-5.3.tar.gz"
    sha256 "4115ccee832620df16b659d4653568331015c718a754855caf5930805d76924e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/8f/39/77c555d68d317457a10a30f4a92ae4a315a4ee0e05e9af7c0ac5c301df10/ruamel.yaml-0.15.35.tar.gz"
    sha256 "8dc74821e4bb6b21fb1ab35964e159391d99ee44981d07d57bf96e2395f3ef75"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/48/d8/25d9b4b875ab3c2400ec7794ceda8093b51101a9d784da608bf65ab5f5f5/smmap2-2.0.3.tar.gz"
    sha256 "c7530db63f15f09f8251094b22091298e82bf6c699a6b8344aaaef3f2e1276c3"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/83/91/162f2c76729633d1dc36b09746895c7766bc183bba94cb4d2ec398676060/websocket_client-0.46.0.tar.gz"
    sha256 "933f6bbf08b381f2adbca9e93d7e7958ba212b42c73acb310b18f0fbe74f3738"
  end

  def install
    bash_completion.install "completion/bash-completion" => "fdroid"
    venv = virtualenv_create(libexec, "python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      ENV.delete "SDKROOT"
      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
    doc.install "examples"
  end

  def caveats; <<~EOS
    In order to function, fdroidserver requires that the Android SDK's
    "Build-tools" and "Platform-tools" are installed.  Also, it is best if the
    base path of the Android SDK is set in the standard environment variable
    ANDROID_HOME.  To install them from the command line, run:
    android update sdk --no-ui --all --filter tools,platform-tools,build-tools-25.0.0
    EOS
  end

  test do
    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath/"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      open("config.py", "w") do |f|
        f << "gradle = 'gradle'"
      end

      open("metadata/fake.txt", "w") do |f|
        f << "License:GPL-3.0\n"
        f << "Summary:Yup still fake\n"
        f << "Categories:Internet\n"
        f << "Description:\n"
        f << "this is fake\n"
        f << ".\n"
      end

      system "#{bin}/fdroid", "checkupdates", "--verbose"
      system "#{bin}/fdroid", "lint", "--verbose"
      system "#{bin}/fdroid", "rewritemeta", "fake", "--verbose"
      system "#{bin}/fdroid", "scanner", "--verbose"

      # TODO: enable once Android SDK build-tools are reliably installed
      # ENV["ANDROID_HOME"] = Formula["android-sdk"].opt_prefix
      # system "#{bin}/fdroid", "readmeta", "--verbose"
      # system "#{bin}/fdroid", "init", "--verbose"
      # assert_predicate Pathname.pwd/"config.py", :exist?
      # assert_predicate Pathname.pwd/"keystore.jks", :exist?
      # system "#{bin}/fdroid", "update", "--create-metadata", "--verbose"
      # assert_predicate Pathname.pwd/"metadata", :exist?
      # assert_predicate Pathname.pwd/"repo/index.jar", :exist?
    end
  end
end
