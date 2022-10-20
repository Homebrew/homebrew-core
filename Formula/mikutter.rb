class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter-5.0.4.tar.gz", using: :homebrew_curl
  sha256 "875a8009241ad312c0bc2be0df9d64461d29410564124f306cf443e316fa1732"
  license "MIT"
  head "git://mikutter.hachune.net/mikutter.git", branch: "develop"

  livecheck do
    url "https://mikutter.hachune.net/download"
    regex(/href=.*?mikutter.?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c089f125435d7b6ac9f62c4d4a574969c2cbdc5fbfde5ddcd333b8c6701f9ba4"
    sha256 cellar: :any,                 arm64_big_sur:  "1afb77f61820623e9f00cd2936a0fb1c4df96a057c1696b0b4c0c48eebd7151b"
    sha256 cellar: :any,                 monterey:       "a165a349a4c3a2aa330655469de7245fef2c8d35bd3fb208dbac6f427660ac1c"
    sha256 cellar: :any,                 big_sur:        "15bc6b8b80a49627520ff46aece52e4166c3d55517edc9fefb636c0bf92af1b3"
    sha256 cellar: :any,                 catalina:       "3785bf435b7fab2777bbf549415212af55c68154d662d9c9ad89a5b69368b240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e27fdcad2e525c1a33b874b8e291609af6bd81500446b5452e8c9a848bf8b459"
  end

  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "ruby@2.7"

  on_macos do
    depends_on "terminal-notifier"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.0.gem"
    sha256 "f76d29d2d1f54b6c6a49aec58f9583b08d97e088c227a3fcba92f6c6531d5908"
  end

  resource "atk" do
    url "https://rubygems.org/downloads/atk-3.4.9.gem"
    sha256 "23ea67070792379592d595dcbcb229168f0f19865f3a358c4a33277ebf48f843"
  end

  resource "cairo" do
    url "https://rubygems.org/downloads/cairo-1.17.7.gem"
    sha256 "7899b1927943b7f154d1c2db3047c81267fbb35c4e983f976f25a5d64d7288ec"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/downloads/cairo-gobject-3.4.9.gem"
    sha256 "88f3171d9f14c386f2e79d356724ee10aff1a582fed04f6e029e3396912055e1"
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

  resource "forwardable" do
    url "https://rubygems.org/downloads/forwardable-1.3.2.gem"
    sha256 "6ae8df9e8f97d7b10adb0ca5170efb2d45a0681127884c4ce05b9a43c3f25080"
  end

  resource "gdk3" do
    url "https://rubygems.org/downloads/gdk3-3.4.9.gem"
    sha256 "7e298ef9e8fd1edb43eb66d981838f0450eb6c4897d8f40281d0d317184e8ed0"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/downloads/gdk_pixbuf2-3.4.9.gem"
    sha256 "143863f852f2c36bee748d2fe19bc6323d155e18834b064a5ca659dabe5cd861"
  end

  resource "gettext" do
    url "https://rubygems.org/downloads/gettext-3.4.1.gem"
    sha256 "de618ae3dae3580092fbbe71d7b8b6aee4e417be9198ef1dce513dff4cc277a0"
  end

  resource "gio2" do
    url "https://rubygems.org/downloads/gio2-3.4.9.gem"
    sha256 "3f44af21628ffa4dbaf6b404101acc4514be36dc33557011e493d4814986a765"
  end

  resource "glib2" do
    url "https://rubygems.org/downloads/glib2-3.4.9.gem"
    sha256 "286f6b9032385f170d23eabc18f39be854bc9f20d65f0028e5365f3754a845dc"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/downloads/gobject-introspection-3.4.9.gem"
    sha256 "a63985c90f0914e2827f7b75bbab103edfeaf968d8670eedc0cc6452ecd52e83"
  end

  resource "gtk3" do
    url "https://rubygems.org/downloads/gtk3-3.4.9.gem"
    sha256 "af53ca3dc393d6a118a2dd349c40796c595374a760fd84f1fc236a4e5e324785"
  end

  resource "httpclient" do
    url "https://rubygems.org/downloads/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "instance_storage" do
    url "https://rubygems.org/downloads/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "locale" do
    url "https://rubygems.org/downloads/locale-2.1.3.gem"
    sha256 "b6ddee011e157817cb98e521b3ce7cb626424d5882f1e844aafdee3e8b212725"
  end

  resource "matrix" do
    url "https://rubygems.org/downloads/matrix-0.4.2.gem"
    sha256 "71083ccbd67a14a43bfa78d3e4dc0f4b503b9cc18e5b4b1d686dc0f9ef7c4cc0"
  end

  resource "memoist" do
    url "https://rubygems.org/downloads/memoist-0.16.2.gem"
    sha256 "a52c53a3f25b5875151670b2f3fd44388633486dc0f09f9a7150ead1e3bf3c45"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.0.gem"
    sha256 "1e06b286ff19b73cfc9193cb3dd2bd80416f8262443564b25b23baea74a05765"
  end

  resource "moneta" do
    url "https://rubygems.org/downloads/moneta-1.5.1.gem"
    sha256 "2b857c962b4efa1826da7d3c2b03566b8e93bb75585a1c9ec3e16e8146f0b82e"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/downloads/native-package-installer-1.1.5.gem"
    sha256 "516ebbacd7382b7e424da96eda6666d60dfad4dd407245a6ad5c1ad94e803ae4"
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.13.8.gem"
    sha256 "79c279298b2f22fd4e760f49990c7930436bac1b1cfeff7bacff192f30edea3c"
  end

  resource "oauth" do
    url "https://rubygems.org/downloads/oauth-0.5.10.gem"
    sha256 "c31c1f70825ae8a8f456618e7d7ed9092bef7f41878195530eeebfff56ee59ab"
  end

  resource "pango" do
    url "https://rubygems.org/downloads/pango-3.4.9.gem"
    sha256 "976ec073cc137b7a27e3a40127a1f30ca2a016c6851fff74944dd0581362922b"
  end

  resource "pkg-config" do
    url "https://rubygems.org/downloads/pkg-config-1.4.9.gem"
    sha256 "14968c3fec94a66f53a273b74478ed6372f2cf9a08bc081ba7642878ebac3b6d"
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
    url "https://rubygems.org/downloads/public_suffix-4.0.7.gem"
    sha256 "8be161e2421f8d45b0098c042c06486789731ea93dc3a896d30554ee38b573b8"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.6.0.gem"
    sha256 "2dede3b136eeabd0f7b8c9356b958b3d743c00158e2615acab431af141354551"
  end

  resource "rake" do
    url "https://rubygems.org/downloads/rake-13.0.6.gem"
    sha256 "5ce4bf5037b4196c24ac62834d8db1ce175470391026bd9e557d669beeb19097"
  end

  resource "red-colors" do
    url "https://rubygems.org/downloads/red-colors-0.3.0.gem"
    sha256 "9dc9e5c4c78e9504108394b64f9c52fec7620d35e1d482925daa9487d95a16f7"
  end

  resource "singleton" do
    url "https://rubygems.org/downloads/singleton-0.1.1.gem"
    sha256 "b410b0417fcbb17bdfbc2d478ddba4c91e873d6e51c9d2d16b345c5ee5491c54"
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

    ruby_series = Formula["ruby@2.7"].any_installed_version.major_minor
    env = {
      DISABLE_BUNDLER_SETUP: "1",
      GEM_HOME:              HOMEBREW_PREFIX/"lib/mikutter/vendor/ruby/#{ruby_series}.0",
      GTK_PATH:              HOMEBREW_PREFIX/"lib/gtk-2.0",
    }

    (bin/"mikutter").write_env_script Formula["ruby@2.7"].opt_bin/"ruby", "#{libexec}/mikutter.rb", env
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
