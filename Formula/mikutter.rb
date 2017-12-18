class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.5.15.tar.gz"
  sha256 "1e970525b692be1a109d25e529969f64540eff31ace5149c4d2056f1c34e4150"
  revision 2
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "e92b36405da63a293c7e0a5403f5a4ac169244c671b3754231b80be4790ae950" => :high_sierra
    sha256 "5ebd403b2b44bf1f20987b5818c12521402bb5d7f5c11f3ea5d649f297bff02d" => :sierra
    sha256 "585042a808c140a313dccd73d2b58245f925496104d7a61d576b8b4170c8eecb" => :el_capitan
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.2.gem"
    sha256 "73771ea960b3900d96e6b3729bd203e66f387d0717df83304411bf37efd7386e"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.1.9.gem"
    sha256 "b5639c7482863ba723cb7412225d116019125ea7cb4c8453b1190964f64b89a2"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.10.gem"
    sha256 "ec7076193db97bea42515aa737ea4574f2353375965f34dcf99219c94e0116b8"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.1.9.gem"
    sha256 "46600a2cc1819185f2d2c6babec974d9808df2b3df4112058586e101446adae2"
  end

  resource "crack" do
    url "https://rubygems.org/gems/crack-0.4.3.gem"
    sha256 "5318ba8cd9cf7e0b5feb38948048503ba4b1fdc1b6ff30a39f0a00feb6036b29"
  end

  resource "delayer" do
    url "https://rubygems.org/gems/delayer-0.0.2.gem"
    sha256 "39ece17be3e4528d562a88aef7cb25143ef4ce77df2925a7534f8a163af1db94"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/gems/delayer-deferred-1.0.4.gem"
    sha256 "6bef17fec576f81fb74db5b6d1b883abec1824976120ccf99f413f34e385e2e6"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.1.9.gem"
    sha256 "ed004f3078bc0cb85db15778ea7a18b8f68375d0ee37dfd22146707c8eb2fb74"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.0.9.gem"
    sha256 "390ee547437d62d00b859383d1af816cf06f0adee9ced1949f821b720d187c93"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.1.9.gem"
    sha256 "15726e8e2ce5b17bf05c957fd699248a83b2e64ea303c1adaf2954316e57beb7"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.1.9.gem"
    sha256 "e340b2f436349eaae22dc344c72bbda75d76500f34e2193942aa905112d23cf8"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.1.9.gem"
    sha256 "a3ea43cd92f339835db241bb2b4678f87b7e4fe68072ca9369e0219fbe51f411"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.1.9.gem"
    sha256 "78ce0919a029645de69e823ce1bb5c4e295094d4169f7099e385832eb87e50d7"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.7.gem"
    sha256 "e94a08689f724a571556b78d5ca35214033d3961972d58c4611245c4b3a0457a"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
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

  resource "metaclass" do
    url "https://rubygems.org/gems/metaclass-0.0.4.gem"
    sha256 "8569685c902108b1845be4e5794d646f2a8adcb0280d7651b600dab0844fe942"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.3.0.gem"
    sha256 "216417b241ff4e7b1c726f257241eaf223e3abbe6ec2c6453352dea6a414a38d"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-0.14.0.gem"
    sha256 "4bb00fdc69d628b15ad2b89ca6f490aaf92486f640282b8943fe3b43dee9a145"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.0.0.gem"
    sha256 "2224e5a68156e8eceb525fb0582c8c4e0f29f67cae86507cdcfb406abbb1fc5d"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/gems/native-package-installer-1.0.5.gem"
    sha256 "c299002a4a05652598c26614a0fc4b75bc2c619d253e0db775d419382e0b54b9"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.8.1.gem"
    sha256 "4180dd5dfe8ba5479db7c3030012cd79da9b958eea472195f3daa23cbf80bd80"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.3.gem"
    sha256 "0b3412bf8114cc9c87abebae4b858216a9bf453192ea3069d5bd8e7ad373aca8"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.1.9.gem"
    sha256 "5342636aec2737e83003c0364f323eab0e70ca5911c4ac32a652b6003468946b"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.2.8.gem"
    sha256 "9aff7ab9d6aea2218dba94791a1b3ba6f149fa57dc9c81634e54f0c59959d814"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-1.1.1.gem"
    sha256 "3f9221717f88faf246e1d7a59276bb44741f0c0b000974c65cd47aad280b1a40"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-3.0.1.gem"
    sha256 "67182699cb644e66b4c68d30b5f1dd42e3dfe6c0aa0d8fd36a1e71c97c6a7f57"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-10.5.0.gem"
    sha256 "2b55a1ad44b5c945719d8a97c302a316af770b835187d12143e83069df5a8a49"
  end

  resource "ruby-hmac" do
    url "https://rubygems.org/gems/ruby-hmac-0.4.0.gem"
    sha256 "a4245ecf2cfb2036975b63dc37d41426727d8449617ff45daf0b3be402a9fe07"
  end

  resource "ruby-prof" do
    url "https://rubygems.org/gems/ruby-prof-0.16.2.gem"
    sha256 "4fcd93dba70ed6f90ac030fb42798ddd4fbeceda37b15cfacccf49d5587b2378"
  end

  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.4.gem"
    sha256 "248193992ef1730a0c9ec579999ef2256a2b3a32a9bd9d708a1e12544a489ec2"
  end

  resource "test-unit" do
    url "https://rubygems.org/gems/test-unit-3.2.6.gem"
    sha256 "db329c4721e02964d63f0c78a99f71c7341e8dc5a4f41f14a856fb659a5885be"
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
    url "https://rubygems.org/gems/twitter-text-1.14.7.gem"
    sha256 "6fbf511d449d61a2e2198dd758622193aa74d6e95a6ec7111725cce0e181629c"
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
    url "https://rubygems.org/gems/unf_ext-0.0.7.4.gem"
    sha256 "8b3e34ddcc5db65c6e0c9f34b5bd62720e770ba04843d601c3730c887f131992"
  end

  resource "watch" do
    url "https://rubygems.org/gems/watch-0.1.0.gem"
    sha256 "1d3e767cb917f226cb970ac0e39c9ee613f9082a390598bf94be516bbd79e409"
  end

  resource "webmock" do
    url "https://rubygems.org/gems/webmock-1.24.6.gem"
    sha256 "c516e1b309697af303e647dc2f3c7222b13ef70c1c4c5afb61e64bd595c9740f"
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
    EOS
    system bin/"mikutter", "plugin_depends",
           testpath/".mikutter/plugin/test_plugin/test_plugin.rb"
    system bin/"mikutter", "--plugin=test_plugin", "--debug"
  end
end
