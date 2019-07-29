class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.8.8.tar.gz"
  sha256 "cbecf86f59f2c75295f489b5dfd2f283f8e638639303233acb6dbe79b27d3430"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "ba043509638d263bd73ce2d20f015a5aed06987c408e1a5530004525b99bcd89" => :mojave
    sha256 "a68a249e92e639e9f60d454fad0f8923622757dd81f5e0cfabce9c4fa541ddad" => :high_sierra
    sha256 "cbbfdd36153ebb931f88dd2a531b6c28ec599b5fee6edf16ab0c92c3d2e97efd" => :sierra
  end

  depends_on "gobject-introspection"
  depends_on "gtk+"
  depends_on "libidn"
  depends_on "ruby"
  depends_on "terminal-notifier"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.6.0.gem"
    sha256 "d490ad06dfc421503e659a12597d6bb0273b5cd7ff2789a1ec27210b1914952d"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.3.6.gem"
    sha256 "d11df1ccee53348ef16d1b39bfbbadd41f5d8d6fe639b10bb7e5ab347b6c4c3e"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.16.4.gem"
    sha256 "e81e58381f1d4059bdd96ae8dc6c26aa0d6169ddd1d56c035f7f79bd18157b7b"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.3.6.gem"
    sha256 "c9d0b286ab94abb971cbc40448215597cfcc68a8cf088a7bd1acc148373cda16"
  end

  resource "delayer" do
    url "https://rubygems.org/gems/delayer-1.0.0.gem"
    sha256 "a8f0196fa06688f9ae6c36c764aba80f7bcbe46f48da49a6c8775c2883f77f57"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/gems/delayer-deferred-2.1.0.gem"
    sha256 "a41e5ab0dc86833b988ff410c3aaa1db6d85d653be16204cd223db38057c05f6"
  end

  resource "diva" do
    url "https://rubygems.org/gems/diva-1.0.0.gem"
    sha256 "fc5cc31c28475439fbd1bc12350b96518c897e93e7f687298a9ae82de16f88e0"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.3.6.gem"
    sha256 "ca6fd75cd2700bbba80d32cb109922f615aa20451f8d8ef64d0f0cd1e5182e89"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.2.9.gem"
    sha256 "990392498a757dce3936ddaf4a65fefccbdf0ca9c62d51af57c032f58edcc41c"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.3.6.gem"
    sha256 "93f180c014d40d3c690e55302404740ef4ceacf932bcdc1f2edf68faad88003b"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.3.6.gem"
    sha256 "0cfbef89bbe8730f00ad600d2934def2331276b2fb2bf555d855d6c45bd9f889"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.3.6.gem"
    sha256 "5bca95085714579ba5ea46058421885e9eb853ea6648b1baa1b3a8e55a3bc748"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.3.6.gem"
    sha256 "70054dbe79abf49cbb5a713bfd53c187710337bc13cde82afbc7461742f7f72b"
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
    url "https://rubygems.org/gems/json_pure-2.2.0.gem"
    sha256 "6910b486d147c7d90239815f8f77344350d98d583ae23fc5e1bb82cd5d0d1254"
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
    url "https://rubygems.org/gems/mini_portile2-2.4.0.gem"
    sha256 "7e178a397ad62bb8a96977986130dc81f1b13201c6dd95a48bd8cec1dda5f797"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.1.1.gem"
    sha256 "25f19d3e758285481266f61e5a5ffc2ea4a451a7bc220090faf08ec0064f7ad5"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/gems/native-package-installer-1.0.7.gem"
    sha256 "d6f9330f74d10d7fe895e4b71c957565793d993a8319cfdb42c91d8026fc190f"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.10.3.gem"
    sha256 "4497d9bb5a5ae841176fa7f668608bfe6e5652d0b4a6edbe2ea1480063f37209"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.4.gem"
    sha256 "3e017ed1c107eb6fe42c977b78c8a8409249869032b343cf2f23ac80d16b5fff"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.3.6.gem"
    sha256 "6a0e61155d1545a62e2803986486d6254ffad136b3a55e66e94f3209788e688a"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.3.7.gem"
    sha256 "216fdf7ecd753dcc258cf516e1843f8e354c155b0aef2428f36e60c840f5a6e8"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.2.0.gem"
    sha256 "108eb89db1cc35f94f69d838f673d9d501b7e1f57e8eec5e200cb1d8a4cc60bf"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-3.1.0.gem"
    sha256 "b4987145e735f706a8c897f2643048abf9dab7b70b8a5388e430a43e7b2fecb0"
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
    url "https://rubygems.org/gems/twitter-text-3.0.0.gem"
    sha256 "5d4921485440e704e651a1c5ed4d94d13eac699cf4fef328bc006798e82273c5"
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
    url "https://rubygems.org/gems/unf_ext-0.0.7.6.gem"
    sha256 "ae5bf2c42c6ed31942972faaf39c7bfdd97aa44530852e37c701c11589e186d2"
  end

  def install
    (lib/"mikutter/vendor").mkpath
    resources.each do |r|
      r.fetch
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

      exec #{which("ruby")} "#{libexec}/mikutter.rb" "$@"
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
