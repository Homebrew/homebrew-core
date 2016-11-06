class Mikutter < Formula
  desc "Extensible Twitter client."
  homepage "http://mikutter.hachune.net"
  url "http://mikutter.hachune.net/bin/mikutter.3.4.6.tar.gz"
  sha256 "143318ad39ec60c9cf83e206f1a940e9464f0fda19c61e5e13a6cf327d1db076"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "bb9d615537dfe5c577f94970732f81f86293ff870e81c8b3c147a555d93413e8" => :sierra
    sha256 "1c77d12d977e0460db518169f0207a9b610ec01bc3ce22ca87ff9228b2a94208" => :el_capitan
    sha256 "ed87b683da08b1f759b753ae458d606d2b6c315c278f11b2db54fbcc6f76f099" => :yosemite
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "rake" do
    url "https://rubygems.org/gems/rake-10.5.0.gem"
    sha256 "2b55a1ad44b5c945719d8a97c302a316af770b835187d12143e83069df5a8a49"
  end

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.4.0.gem"
    sha256 "7abfff765571b0a73549c9a9d2f7e143979cd0c252f7fa4c81e7102a973ef656"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.1.7.gem"
    sha256 "1f3cd171432f4634805ebf7cd187d1d728d732bfead3837c349f2c502d8e9252"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.0.9.gem"
    sha256 "5981cf42e73c13b4744b5ad80eeba12a2ac5b9114d81c000c5be11dc00401f24"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.0.9.gem"
    sha256 "aba2b0201cfaecd9bd82437794aba9b4b3a6b6214fbd1c2264c2294d8ef4fa39"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.2.gem"
    sha256 "954cb9bf7ac7cc79a5cc805be61ca81378454f20f621939fa6afb4513cab50d9"
  end

  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.4.gem"
    sha256 "248193992ef1730a0c9ec579999ef2256a2b3a32a9bd9d708a1e12544a489ec2"
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
    url "https://rubygems.org/gems/gdk_pixbuf2-3.0.9.gem"
    sha256 "596ac6012ea35d75a1236f2b9286fa153c467c777ea7833f5ab12f6e7c313c9c"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.2.gem"
    sha256 "1db4a6b5f21fcd64f397d61bf2af69840dc11b3176d1fa6d75a0e749f04a9aea"
  end

  resource "text" do
    url "https://rubygems.org/gems/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.0.9.gem"
    sha256 "390ee547437d62d00b859383d1af816cf06f0adee9ced1949f821b720d187c93"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.0.9.gem"
    sha256 "7b3c4355beba7d755c748753a88450f0f5818871b27b647c6a942bb6626e9016"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.0.9.gem"
    sha256 "d39b461a3cd86990a9c0293828346579685e907c0bc4a47b6a325cb3a81f1556"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.0.9.gem"
    sha256 "d45e3cd42eb3e321441ed38723b6aefe98787566c339c6cd68992e8a4dc1702c"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.0.9.gem"
    sha256 "45e4df14d5c6b071a3744c1b1d371f6a87faecfc8c66f1cb1f24370eb7f9116c"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.0.gem"
    sha256 "04844d6f841e96ead0f1453597a92045cae5abb1c74fc0fcf790dc8fb27a06e4"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.2.4.gem"
    sha256 "46d98a0ea59a4fefce65909e1880b9df931c27c0821aaaf395c50a59df72a2d9"
  end

  resource "instance_storage" do
    url "https://rubygems.org/gems/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-1.8.3.gem"
    sha256 "24311db8ff882cbb0d32385ca2f90523bfd3b3ae17bd2a436ea60333f2f4aa08"
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
    url "https://rubygems.org/gems/mini_portile2-2.1.0.gem"
    sha256 "0b0e83fe0fc190640a93c48cef0c8e1f1f40f77840d82c160fefc1b07a5345f8"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-0.14.0.gem"
    sha256 "4bb00fdc69d628b15ad2b89ca6f490aaf92486f640282b8943fe3b43dee9a145"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-0.8.0.gem"
    sha256 "80c1372a661119dd05c44a5f3f5b0b3a7dce823f7fbf78017f88baa92aae0b39"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.6.8.1.gem"
    sha256 "92814a7ff672e42b60fd5c02d75b62ab8fd2df3afbac279cc8dadac3c16bbd10"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.1.gem"
    sha256 "7e0a43c527af605dc1fc3ef8416d2641b400078d8a22e30981ac47d81af290ab"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-0.3.1.gem"
    sha256 "f89ba9cc1fa9d684b8f9f1221e94a8472a89355b5a6cb40d99fc863cbb4bec3a"
  end

  resource "ruby-hmac" do
    url "https://rubygems.org/gems/ruby-hmac-0.4.0.gem"
    sha256 "a4245ecf2cfb2036975b63dc37d41426727d8449617ff45daf0b3be402a9fe07"
  end

  resource "test-unit" do
    url "https://rubygems.org/gems/test-unit-3.2.1.gem"
    sha256 "50599b29ba3edf1aa924bca6341989fdd27e5c72d4d5bb66dfc65fc5f7cbcfb0"
  end

  resource "totoridipjp" do
    url "https://rubygems.org/gems/totoridipjp-0.1.0.gem"
    sha256 "93d1245c5273971c855b506a7a913d23d6f524e9d7d4494127ae1bc6174c910d"
  end

  resource "unf_ext" do
    url "https://rubygems.org/gems/unf_ext-0.0.7.2.gem"
    sha256 "e8fa13d09880f8d06d30a86f929a38ba0af6abe61272927a49e6796aee1aa111"
  end

  resource "unf" do
    url "https://rubygems.org/gems/unf-0.1.4.gem"
    sha256 "4999517a531f2a955750f8831941891f6158498ec9b6cb1c81ce89388e63022e"
  end

  resource "twitter-text" do
    url "https://rubygems.org/gems/twitter-text-1.14.0.gem"
    sha256 "8c60d5be2dcfe19bb97d2f2549296cf5d4f52199de85ea7bb66e1196193cd294"
  end

  resource "typed-array" do
    url "https://rubygems.org/gems/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
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
