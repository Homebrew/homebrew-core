class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.5.6.tar.gz"
  sha256 "6152cdf9203ed8ff2a5d862c5d6fa76953b399caf21ad93c6bdc920b7c35ee8c"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "87eae501fc1b9325aa55617f3397d8144d26e5085acbdbd7063d64e76678dde8" => :sierra
    sha256 "fb386c38d778695cd2d59ed2dac133bb24258919fbc18d128d52267151af1ff7" => :el_capitan
    sha256 "2ab6075472a8894a9f22cf99abba91004a00349f53e1111369821fcb4f969883" => :yosemite
  end

  depends_on "gtk+"
  depends_on "terminal-notifier" => :recommended
  depends_on :ruby => "2.1"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.1.gem"
    sha256 "b09603b313a94fa3674d8fbaae77cc7c778e9d3cde5fea3b7c1fe447941818c5"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.1.1.gem"
    sha256 "3f4b81d7e478910385bbf55ba2fb4cadb26bd551b1547abbc3776893ca43a89f"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.5.gem"
    sha256 "442a290fd9dda3fff1a154a2338464da9a59c1f7bf7cfbac647418e5eb3f5692"
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
    url "https://rubygems.org/gems/gdk_pixbuf2-3.1.1.gem"
    sha256 "01c23cb6543990b70100c0b9ddcc41210c43e5060ccf7f701cce44f795fe2e75"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.2.2.gem"
    sha256 "9d250bb79273efb4a268977f219d2daca05cdc7473eff40288b8ab8ddd0f51b4"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.1.1.gem"
    sha256 "8490980e56ece390527dfefe50bdd22a663c962dd8793f33159773618d68328c"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.1.1.gem"
    sha256 "bcb07a66e7eef16fa5a800f2fd88504ae9b0b7dea81cc6c0a46f760306758b01"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.2.gem"
    sha256 "5682c6e510f224d3c42c885d80d15d3dc0effadde5ed4920cd727acf2cb939e0"
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
    url "https://rubygems.org/gems/json_pure-2.0.3.gem"
    sha256 "3af4187a03a37cadc93c81fd7333ea8aac5d92d22609af448aa4fb060dd73850"
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
    url "https://rubygems.org/gems/mini_portile2-2.1.0.gem"
    sha256 "0b0e83fe0fc190640a93c48cef0c8e1f1f40f77840d82c160fefc1b07a5345f8"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-1.2.1.gem"
    sha256 "7de99b005aa41dc46841442afe468451a145f2c6d9b10fac0c23f0d911bef50d"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.0.0.gem"
    sha256 "2224e5a68156e8eceb525fb0582c8c4e0f29f67cae86507cdcfb406abbb1fc5d"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.7.1.gem"
    sha256 "1ed8277b920c77d2130b65b81e20ef53d9bd2e9e092bc01e9ecc5dc3237b15ba"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.1.gem"
    sha256 "7e0a43c527af605dc1fc3ef8416d2641b400078d8a22e30981ac47d81af290ab"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.1.1.gem"
    sha256 "7ed9d940fe40ff821092bf2d061d20ee7abde0daf16ab7d53dab36f229118ca1"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.1.7.gem"
    sha256 "1f3cd171432f4634805ebf7cd187d1d728d732bfead3837c349f2c502d8e9252"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-1.0.1.gem"
    sha256 "a51f4adaaf3d73dd87c12ab3f2d95b86f94ec1090af7970b63ba5281a0eda8ed"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-2.0.5.gem"
    sha256 "f8488b110921532ff291af74eef70fa4e3c036141c4ef80009dcdc2b51721210"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-12.0.0.gem"
    sha256 "f6b43059e2923ddd30128fbbf4eb2e610c020b888ad97b57d7d94abc12734806"
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
    url "https://rubygems.org/gems/test-unit-3.2.3.gem"
    sha256 "fe125f1418b223b9d84ea12c2557d87ccc98d2c4ae5b7ef63c75611dc4edcfce"
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
    url "https://rubygems.org/gems/twitter-text-1.14.5.gem"
    sha256 "5e04dcddc13e71b75938c7219501c43ef122139b18686229d83ed4b93955e2d9"
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
    url "https://rubygems.org/gems/unf_ext-0.0.7.2.gem"
    sha256 "e8fa13d09880f8d06d30a86f929a38ba0af6abe61272927a49e6796aee1aa111"
  end

  resource "watch" do
    url "https://rubygems.org/gems/watch-0.1.0.gem"
    sha256 "1d3e767cb917f226cb970ac0e39c9ee613f9082a390598bf94be516bbd79e409"
  end

  resource "webmock" do
    url "https://rubygems.org/gems/webmock-2.3.2.gem"
    sha256 "c5339ec35be0e119fd928b453a1b8def6e3210b33ade33c443d7ba5535661312"
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
