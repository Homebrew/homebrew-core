class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.6.6.tar.gz"
  sha256 "fd3316e21541dca160a4f6d922e3d0ed53b782a43127ab5cf2c50b838f439aa3"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "537362267bdc780230b09f182f328eee50050421b03c4cd57037d4d72b4b44e1" => :high_sierra
    sha256 "a830d27def89b6c729f01a0cfc6ebda2f1253fef97ebef328ec5b140e2407337" => :sierra
    sha256 "0943890d1627fed8822d915b805a0a3bf225eb777325a95848619ebb5bdab9f7" => :el_capitan
  end

  depends_on "gobject-introspection"
  depends_on "gtk+"
  depends_on "libidn"
  depends_on "ruby"
  depends_on "terminal-notifier" => :recommended

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.2.gem"
    sha256 "73771ea960b3900d96e6b3729bd203e66f387d0717df83304411bf37efd7386e"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.2.4.gem"
    sha256 "6b2d10b4585414b4e2ed525d589de1c75752f5d18aad1c7015d020a3770778ff"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.12.gem"
    sha256 "c4f3240a3da1ff3962ab30bd58f17c717ad5b1cee89744a34f0442bdfbce26ea"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.2.4.gem"
    sha256 "d15155d5255c8c4e239732b051adc3ff9958d83e502e27eca7abe69be13990e1"
  end

  resource "delayer" do
    url "https://rubygems.org/gems/delayer-0.0.2.gem"
    sha256 "39ece17be3e4528d562a88aef7cb25143ef4ce77df2925a7534f8a163af1db94"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/gems/delayer-deferred-2.0.0.gem"
    sha256 "bf135b0a76eb30223e447da7afe915726321716856acf5e0e3453efb3dbc787f"
  end

  resource "diva" do
    url "https://rubygems.org/gems/diva-0.3.1.gem"
    sha256 "a8b5151497db49a12778401e20fe3405596a7d3a6a888be98124ec016b20ef58"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.2.4.gem"
    sha256 "407f99db24a562ad6800fd5d13d3475501be060ff0bae672fbfaa69ddbc5e391"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.0.9.gem"
    sha256 "390ee547437d62d00b859383d1af816cf06f0adee9ced1949f821b720d187c93"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.2.4.gem"
    sha256 "f0b04cae9be39add60967a5efceefb011221080e7c35b0d4b88c3940e682b532"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.2.4.gem"
    sha256 "dfca91c050d0d7ee097edf2c974ca0cdcd9e84dd8f37ce1e4bbeba8349951fd4"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.2.4.gem"
    sha256 "3726d51ce5714ac155d676ec633c03f0c48ab203220b021fc11839d2a37e590a"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.2.4.gem"
    sha256 "f004b5e19300dbae3ec6147a4a5d342202564310e783654f83bbe9a9184ad03f"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "idn-ruby" do
    url "https://rubygems.org/gems/idn-ruby-0.1.0.gem"
    sha256 "99abba21c66e61fa16f2ddb2a507b4fd5a8d84ece77711f0d2e2bc313da36b1f"
  end

  resource "instance_storage" do
    url "https://rubygems.org/gems/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-1.8.6.gem"
    sha256 "55d575c4aec98249473811a256b3f3a7c12a94ad008093032f5e5f28eacd94ee"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.2.gem"
    sha256 "1db4a6b5f21fcd64f397d61bf2af69840dc11b3176d1fa6d75a0e749f04a9aea"
  end

  resource "memoist" do
    url "https://rubygems.org/gems/memoist-0.16.0.gem"
    sha256 "70bd755b48477c9ef9601daa44d298e04a13c1727f8f9d38c34570043174085f"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.3.0.gem"
    sha256 "216417b241ff4e7b1c726f257241eaf223e3abbe6ec2c6453352dea6a414a38d"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.0.0.gem"
    sha256 "2224e5a68156e8eceb525fb0582c8c4e0f29f67cae86507cdcfb406abbb1fc5d"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/gems/native-package-installer-1.0.6.gem"
    sha256 "7cff2ddbedc529e5f98422288e198428fcf420d78ffabfd4c88536870dda0c3f"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.8.2.gem"
    sha256 "382af505a11b735e97f52ec6279ea484be7a7560d5599e81def40943601fd515"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.4.gem"
    sha256 "3e017ed1c107eb6fe42c977b78c8a8409249869032b343cf2f23ac80d16b5fff"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.2.4.gem"
    sha256 "2272936c72efcdb15b8a09a95139fa398ebc27d52a673ecab8ac4c6ea5ad6e3e"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.3.0.gem"
    sha256 "c06fb86e46cde092b3f29d6c7f9ea01d27a80e4c492fc6beb18d3f41139a1911"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-3.0.2.gem"
    sha256 "3a0168c33fa0b00886423a2ceb21c74199273ccd01bc250360fc8d18600bb0f4"
  end

  resource "ruby-hmac" do
    url "https://rubygems.org/gems/ruby-hmac-0.4.0.gem"
    sha256 "a4245ecf2cfb2036975b63dc37d41426727d8449617ff45daf0b3be402a9fe07"
  end

  resource "text" do
    url "https://rubygems.org/gems/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "totoridipjp" do
    url "https://rubygems.org/gems/totoridipjp-0.1.0.gem"
    sha256 "93d1245c5273971c855b506a7a913d23d6f524e9d7d4494127ae1bc6174c910d"
  end

  resource "twitter-text" do
    url "https://rubygems.org/gems/twitter-text-2.1.0.gem"
    sha256 "ca4ce1c4bc91c412d5b85c12e12d96aff2b347ca01656a0986981bcb4738fbc5"
  end

  resource "typed-array" do
    url "https://rubygems.org/gems/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  resource "unf" do
    url "https://rubygems.org/gems/unf-0.1.4.gem"
    sha256 "4999517a531f2a955750f8831941891f6158498ec9b6cb1c81ce89388e63022e"
  end

  resource "unf_ext" do
    url "https://rubygems.org/gems/unf_ext-0.0.7.5.gem"
    sha256 "4126717c9ad85bc0d8f62881cabf32e84fe18c47485784d1ba8b0c0fb189e11a"
  end

  def install
    (lib/"mikutter/vendor").mkpath
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system("gem", "install", r.cached_download, "--no-document",
             "--install-dir", "#{lib}/mikutter/vendor")
    end

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    (bin/"mikutter").write(exec_script)
    pkgshare.install_symlink libexec/"core/skin"

    # enable other formulae to install plugins
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
  end

  def exec_script
    <<~EOS
      #!/bin/bash

      export DISABLE_BUNDLER_SETUP=1

      # also include gems/gtk modules from other formulae
      export GEM_HOME="#{HOMEBREW_PREFIX}/lib/mikutter/vendor"
      export GTK_PATH="#{HOMEBREW_PREFIX}/lib/gtk-2.0"

      exec ruby "#{libexec}/mikutter.rb" "$@"
    EOS
  end

  test do
    (testpath/".mikutter/plugin/test_plugin/test_plugin.rb").write <<~EOS
      # -*- coding: utf-8 -*-
      Plugin.create(:test_plugin) do
        require 'logger'

        Delayer.new do
          log = Logger.new(STDOUT)
          log.info("loaded test_plugin")
          exit
        end
      end

      # this is needed in order to boot mikutter >= 3.6.0
      class Post
        def self.primary_service
          nil
        end
      end
    EOS
    system bin/"mikutter", "plugin_depends",
           testpath/".mikutter/plugin/test_plugin/test_plugin.rb"
    system bin/"mikutter", "--plugin=test_plugin", "--debug"
  end
end
