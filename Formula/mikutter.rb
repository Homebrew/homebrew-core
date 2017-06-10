class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.5.8.tar.gz"
  sha256 "a4c6e30d1d9ffbacd1b5b0f33d80e6645bbb053509ed593234d3a37de6b809ae"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "c6cd769ea3d7e3db1b9a68c04870a1cac688b3959e57afb85c93e044d35a3494" => :sierra
    sha256 "80917cd837576a9b0ef73a12713bd21657324916d94232199d0562006a5a649c" => :el_capitan
    sha256 "b6324d4e1c5a614f9f97ec17b4d6d8a472d8794c15be6ea8fde62636db744a9b" => :yosemite
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.1.gem"
    sha256 "b09603b313a94fa3674d8fbaae77cc7c778e9d3cde5fea3b7c1fe447941818c5"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.1.6.gem"
    sha256 "cbd1c61cadb79ee4dda060866a2f0687beebf8b223ad613b50b9dfd4fca9a6c6"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.9.gem"
    sha256 "579727200f724a4da0c259e59bb79289de35ede0668dbe4b08883cc8e3b35325"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.1.6.gem"
    sha256 "cf21dfbcc53964159ec24adfe5109a91555f9cd25bbf9ccb2cccb89d8b13374e"
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
    url "https://rubygems.org/gems/delayer-deferred-1.1.1.gem"
    sha256 "ec5adf6ad3680bf3f95a2ab7ac7996994d6a87e01528429570b2f6854d4484af"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.1.6.gem"
    sha256 "96cbf9ce330dff120a9d2ce23a61526039205af7882cc5edfb5ec4dd41453518"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.0.9.gem"
    sha256 "390ee547437d62d00b859383d1af816cf06f0adee9ced1949f821b720d187c93"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.1.6.gem"
    sha256 "a1f76a8ffe11f81c8255786a2085468bc8af729446741b90924fbcc1094b9512"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.1.6.gem"
    sha256 "d500e3c95fdd41888516c1545276b22549d8c09321fa294e66ddb0152c4fd316"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.1.6.gem"
    sha256 "10dca962c2dc3746b6ed2d00a581270265c56ed7a73e61935a91218ad1b2e4cc"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.1.6.gem"
    sha256 "409e2f73b2e792466d1335f68ac79edf9522cf996faee22236f71ba86f00033f"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.4.gem"
    sha256 "0aac86b2486ad06e5496ac404b3c2f115b31d5ba1e110998fa0aa675e691d0d8"
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
    url "https://rubygems.org/gems/memoist-0.15.0.gem"
    sha256 "b838329d7fe7e067e0d0717828db529126f44b8c0c527c884d162ebb4ecba379"
  end

  resource "metaclass" do
    url "https://rubygems.org/gems/metaclass-0.0.4.gem"
    sha256 "8569685c902108b1845be4e5794d646f2a8adcb0280d7651b600dab0844fe942"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.2.0.gem"
    sha256 "f536d3307de76d8ec8cbcc9182a88d83bdc0f8f6e3e9681560166004fcbbab3c"
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
    url "https://rubygems.org/gems/native-package-installer-1.0.4.gem"
    sha256 "4a20c4c74681d60075cad4b435f64278e6b09813edef8c41a23f1e7f9e16726b"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.8.0.gem"
    sha256 "d6e693278e3c26f828339705e14a149de5ac824771e59c6cd9e6c91ebad7ced9"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.3.gem"
    sha256 "0b3412bf8114cc9c87abebae4b858216a9bf453192ea3069d5bd8e7ad373aca8"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.1.6.gem"
    sha256 "ae711ef2e38ca007ca38f899dde3fcbf7b7d70afbf9b91b30af50202a333cbe9"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.2.3.gem"
    sha256 "bc193fda2ceb83cd0eeca87e1c9eba8e142dcd785699205246e28b1a7f14a84a"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-1.0.2.gem"
    sha256 "7982eebfef963eebe680b6789b4cc9366d5ac6fe06b906a950856c9b0a610a99"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-2.0.5.gem"
    sha256 "f8488b110921532ff291af74eef70fa4e3c036141c4ef80009dcdc2b51721210"
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
    url "https://rubygems.org/gems/test-unit-3.2.4.gem"
    sha256 "470fe5e582650ea485c7a5c2242fc9b6dc2018d9aa11dab1662a3b672919ab26"
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
    url "https://rubygems.org/gems/twitter-text-1.14.2.gem"
    sha256 "d71abba271418cbe79e28905678a6ec8ae72ccad478865f4cb3fc89f51338d52"
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
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
  end

  def exec_script
    <<-EOS.undent
    #!/bin/bash
    export GEM_HOME="#{HOMEBREW_PREFIX}/lib/mikutter/vendor"
    export DISABLE_BUNDLER_SETUP=1
    export GTK_PATH="#{HOMEBREW_PREFIX}/lib/gtk-2.0"
    exec ruby "#{libexec}/mikutter.rb" "$@"
    EOS
  end

  test do
    test_plugin = <<-EOS.undent
      # -*- coding: utf-8 -*-
      Plugin.create(:brew) do
        Delayer.new { Thread.exit }
      end
    EOS
    (testpath/"plugin/brew.rb").write(test_plugin)
    system bin/"mikutter", "--confroot=#{testpath}", "--plugin=brew", "--debug"
  end
end
