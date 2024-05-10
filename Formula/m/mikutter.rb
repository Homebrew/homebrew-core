class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter-5.0.7.tar.gz", using: :homebrew_curl
  sha256 "34dcabb98572c5c3b5707ebdee41019bf277fa3e20f7e061088b5b1d1aaea39a"
  license "MIT"
  head "git://mikutter.hachune.net/mikutter.git", branch: "develop"

  livecheck do
    url "https://mikutter.hachune.net/download"
    regex(/href=.*?mikutter.?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "874e909394bbcd628880b9ecb1c24bbdcd742f4e9bf70b0124ffc9406a03a530"
    sha256 cellar: :any,                 arm64_ventura:  "3fc62fdf24d802bed6844898757ea6c3ad41199bce35d7695cfcfc18dff2129f"
    sha256 cellar: :any,                 arm64_monterey: "4699f159d4c7e93dd620bbf19cbd3a24d3a98be7aeffa1931463c3ec61cbd980"
    sha256 cellar: :any,                 sonoma:         "175463dd78b4438c99e02707a6ffc2b51cd99133975057274c00a8db3d73a7cf"
    sha256 cellar: :any,                 ventura:        "1ad8bc7f0a40476f9818fc27546d17fa6ce1238b29b8450c7755e653af7d48aa"
    sha256 cellar: :any,                 monterey:       "9b996455b9139e9a05a5e192a6bc3afd60163657f8dad6547b8d26ea678e2965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb63d053caabda978ef73ca377addc05ae0d51b8eccb4c9b8ac1daef02d8e8a"
  end

  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "ruby"

  uses_from_macos "libxml2" # for nokogiri
  uses_from_macos "libxslt" # for nokogiri

  on_macos do
    depends_on "terminal-notifier"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.6.gem"
    sha256 "798f6af3556641a7619bad1dce04cdb6eb44b0216a991b0396ea7339276f2b47"
  end

  resource "atk" do
    url "https://rubygems.org/downloads/atk-4.2.1.gem"
    sha256 "b8040ed25cb206b2d54354ba8f95f365b6db16149b29fd1ab7ca8edcce8b8c86"
  end

  resource "cairo" do
    url "https://rubygems.org/downloads/cairo-1.17.13.gem"
    sha256 "8ca44023747de6c290e71657c4b826f500dc2996ec78759719c28a25757c05a9"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/downloads/cairo-gobject-4.2.1.gem"
    sha256 "fa1735e69c14714fa09e4f647ac56c486baf69d39663ac1789ef2a62d54fc91b"
  end

  resource "delayer" do
    url "https://rubygems.org/downloads/delayer-1.2.1.gem"
    sha256 "393c5e2e199391640814ba57da84f6e849e3f9bb250e0ce571d1f16eacf1b591"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/downloads/delayer-deferred-2.2.0.gem"
    sha256 "5b0b6df6cf646347105252fd189d3cb5e77d8e56c4a9d7f0654a6b6687564d44"
  end

  resource "diva" do
    url "https://rubygems.org/downloads/diva-2.0.1.gem"
    sha256 "bf70f14e092ba9d05ef5a46c6b359b43310c0478cb371a68a3543ca7ae8953d8"
  end

  resource "fiddle" do
    url "https://rubygems.org/downloads/fiddle-1.1.2.gem"
    sha256 "59bd18c38e65cdc36863ab68e3ffd78658b8f025d1d080b218de94370420a074"
  end

  resource "forwardable" do
    url "https://rubygems.org/downloads/forwardable-1.3.3.gem"
    sha256 "f17df4bd6afa6f46a003217023fe5716ef88ce261f5c4cf0edbdeed6470cafac"
  end

  resource "gdk3" do
    url "https://rubygems.org/downloads/gdk3-4.2.1.gem"
    sha256 "74e511471be1ddc70b63272ed37702dbb690bf1b3fded9544c1928355edd7f59"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/downloads/gdk_pixbuf2-4.2.1.gem"
    sha256 "caa2a3df21d50e6f0ee3ed718161eacc47f064645aba8a1a0505d0a2cd033ad3"
  end

  resource "gettext" do
    url "https://rubygems.org/downloads/gettext-3.4.1.gem"
    sha256 "de618ae3dae3580092fbbe71d7b8b6aee4e417be9198ef1dce513dff4cc277a0"
  end

  resource "gio2" do
    url "https://rubygems.org/downloads/gio2-4.2.1.gem"
    sha256 "bfede5ef3af50ddd9ac786a25065d342a8ef0e405d9eea533c33d3b87c38fffe"
  end

  resource "glib2" do
    url "https://rubygems.org/downloads/glib2-4.2.1.gem"
    sha256 "63bb28d488d4cf6923080c5b37d15a24d043f1ee21100b43407c06f1e5987b51"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/downloads/gobject-introspection-4.2.1.gem"
    sha256 "535bae9fa07a109e47f57e220e63517e61aed502a9d74a960eae498b1e5cda23"
  end

  resource "gtk3" do
    url "https://rubygems.org/downloads/gtk3-4.2.1.gem"
    sha256 "8d07a7930585cafea15790f9acfc0d6ec5629c91ed9698bfdc2c7ee6ab5560c2"
  end

  resource "httpclient" do
    url "https://rubygems.org/downloads/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "instance_storage" do
    url "https://rubygems.org/downloads/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.7.1.gem"
    sha256 "187ea312fb58420ff0c40f40af1862651d4295c8675267c6a1c353f1a0ac3265"
  end

  resource "locale" do
    url "https://rubygems.org/downloads/locale-2.1.4.gem"
    sha256 "522f9973ef3eee64aac9bca06d21db2fba675fa3d2cf61d21f42d1ca18a9f780"
  end

  resource "matrix" do
    url "https://rubygems.org/downloads/matrix-0.4.2.gem"
    sha256 "71083ccbd67a14a43bfa78d3e4dc0f4b503b9cc18e5b4b1d686dc0f9ef7c4cc0"
  end

  resource "memoist" do
    url "https://rubygems.org/downloads/memoist-0.16.2.gem"
    sha256 "a52c53a3f25b5875151670b2f3fd44388633486dc0f09f9a7150ead1e3bf3c45"
  end

  # needed by nokogiri
  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.5.gem"
    sha256 "7a37db8ae758086c3c3ac3a59c036704d331e965d5e106635e4a42d6e66089ce"
  end

  resource "moneta" do
    url "https://rubygems.org/downloads/moneta-1.6.0.gem"
    sha256 "73f4dfc690399b3e5093d36f3a07c2b2dc174e414fa8e14bd90ab82b2d9644c0"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/downloads/native-package-installer-1.1.9.gem"
    sha256 "fbb41b6b22750791a4304f0a0aeea3dd837668892117f49c4caf2e8e0f4e792f"
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.16.3.gem"
    sha256 "498aa253ccd5b89a0fa5c4c82b346d22176fc865f4a12ef8da642064d1d3e248"
  end

  resource "pango" do
    url "https://rubygems.org/downloads/pango-4.2.1.gem"
    sha256 "9e8431164dbce8a151f4994b8996809fb83b9b95753e7d33c23938f1e824f4d2"
  end

  resource "pkg-config" do
    url "https://rubygems.org/downloads/pkg-config-1.5.6.gem"
    sha256 "ca2b5afd09e580112f759e29c88bc033c6f226efd53d54924e5b101e8a3d9113"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/downloads/pluggaloid-1.7.0.gem"
    sha256 "81ab86af2a09f5cfaa5a0c1e8ae8c77242726901a16dbfadb1d9509ad6787eeb"
  end

  resource "prime" do
    url "https://rubygems.org/downloads/prime-0.1.2.gem"
    sha256 "d4e956cadfaf04de036dc7dc74f95bf6a285a62cc509b28b7a66b245d19fe3a4"
  end

  resource "public_suffix" do
    url "https://rubygems.org/downloads/public_suffix-5.0.4.gem"
    sha256 "35cd648e0d21d06b8dce9331d19619538d1d898ba6d56a6f2258409d2526d1ae"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.7.3.gem"
    sha256 "b785ab8a30ec43bce073c51dbbe791fd27000f68d1c996c95da98bf685316905"
  end

  # needed by atk
  resource "rake" do
    url "https://rubygems.org/downloads/rake-13.1.0.gem"
    sha256 "be6a3e1aa7f66e6c65fa57555234eb75ce4cf4ada077658449207205474199c6"
  end

  resource "red-colors" do
    url "https://rubygems.org/downloads/red-colors-0.4.0.gem"
    sha256 "2356eba0782ca6c44caa47645fbf942a2b16d85905c35c6e3f80d5ff0c04929a"
  end

  resource "singleton" do
    url "https://rubygems.org/downloads/singleton-0.2.0.gem"
    sha256 "a6cb7304421684d80093859aed38b26035f6e54a38c3e4fe6456cfb56b240563"
  end

  resource "text" do
    url "https://rubygems.org/downloads/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "typed-array" do
    url "https://rubygems.org/downloads/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  # This is annoying - if the gemfile lists test group gems at all,
  # even if we've explicitly requested to install without them,
  # bundle install --cache will fail because it can't find those gems.
  # Handle this by modifying the gemfile to remove these gems.
  def gemfile_remove_test!
    gemfile_lines = []
    test_group = false
    File.read("Gemfile").each_line do |line|
      line.chomp!

      # If this is the closing part of the test group,
      # swallow this line and then allow writing the test of the file.
      if test_group && line == "end"
        test_group = false
        next
      # If we're still inside the test group, skip writing.
      elsif test_group
        next
      end

      # If this is the start of the test group, skip writing it and mark
      # this as part of the group.
      if line.include?("group :test")
        test_group = true
      else
        gemfile_lines << line
      end
    end

    File.open("Gemfile", "w") do |gemfile|
      gemfile.puts gemfile_lines.join("\n")
      # Unmarked dependency of atk
      gemfile.puts "gem 'rake','>= 13.0.1'"
    end
  end

  def install
    (lib/"mikutter/vendor").mkpath
    (buildpath/"vendor/cache").mkpath
    resources.each do |r|
      r.unpack buildpath/"vendor/cache"
    end

    gemfile_remove_test!
    system "bundle", "config",
           "build.nokogiri", "--use-system-libraries"
    system "bundle", "install",
           "--local", "--path=#{lib}/mikutter/vendor"

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    ruby_series = Formula["ruby"].any_installed_version.major_minor.to_s
    env = {
      DISABLE_BUNDLER_SETUP: "1",
      GEM_HOME:              HOMEBREW_PREFIX/"lib/mikutter/vendor/ruby/#{ruby_series}.0",
      GTK_PATH:              HOMEBREW_PREFIX/"lib/gtk-2.0",
    }

    (bin/"mikutter").write_env_script Formula["ruby"].opt_bin/"ruby", "#{libexec}/mikutter.rb", env
    pkgshare.install_symlink libexec/"core/skin"

    # enable other formulae to install plugins
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
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
