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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "855f6850d3909794ccbc28aa00a19a02c4f78a2bacbe1fe81013098cd4569daf"
    sha256 cellar: :any,                 arm64_monterey: "b34087d94cd41f5efa6610f3707da5ce0c2161f9dbf3688094f688f525c6ae8e"
    sha256 cellar: :any,                 arm64_big_sur:  "f0c27d00273fa2502fd748d610bdfe3b4de84bc3443916b081190146db55a5bd"
    sha256 cellar: :any,                 ventura:        "c99dc7e3f5067b97b655f88d280b09a3c2211b1e65fc23cfe8e83987b595e6f2"
    sha256 cellar: :any,                 monterey:       "8e4a56975062388f07cc192b7a90b8c72ed993a4c99187278d0b264475d9fcc2"
    sha256 cellar: :any,                 big_sur:        "101f6e48af4528fb8c077a8c05ed8b54053e735b4196f95319db9f1cc6be03cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20cfd20ec82e1a14a70ddf05c1d77af051676f2c30347c4d3367610abe9e6430"
  end

  depends_on "gobject-introspection"
  depends_on "gtk+3"
  # gtk3==3.4.9 gem error with ruby 3.2: use of undeclared identifier 'rb_cData'
  # https://github.com/ruby-gnome/ruby-gnome/commit/1e5edc85e14dc97d42cd6e5a1bb72dfbf9341b95
  depends_on "ruby@3.1"

  uses_from_macos "libxml2" # for nokogiri
  uses_from_macos "libxslt" # for nokogiri

  on_macos do
    depends_on "terminal-notifier"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.8.1.gem"
    sha256 "bc724a176ef02118c8a3ed6b5c04c39cf59209607ffcce77b91d0261dbadedfa"
  end

  resource "atk" do
    url "https://rubygems.org/downloads/atk-3.4.9.gem"
    sha256 "23ea67070792379592d595dcbcb229168f0f19865f3a358c4a33277ebf48f843"
  end

  resource "cairo" do
    url "https://rubygems.org/downloads/cairo-1.17.8.gem"
    sha256 "584d96bcb1f983f660b2e1ef51485d1d16bbafc97485be02dd2f92f9af5f626a"
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
    url "https://rubygems.org/downloads/forwardable-1.3.3.gem"
    sha256 "f17df4bd6afa6f46a003217023fe5716ef88ce261f5c4cf0edbdeed6470cafac"
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

  resource "hashie" do
    url "https://rubygems.org/downloads/hashie-5.0.0.gem"
    sha256 "9d6c4e51f2a36d4616cbc8a322d619a162d8f42815a792596039fc95595603da"
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
    url "https://rubygems.org/downloads/mini_portile2-2.8.1.gem"
    sha256 "b70e325e37a378aea68b6d78c9cdd060c66cbd2bef558d8f13a6af05b3f2c4a9"
  end

  resource "moneta" do
    url "https://rubygems.org/downloads/moneta-1.5.2.gem"
    sha256 "12a3e2c9dc0d0fc336e4ead85defbb2027c32428b04aec741a6d0a0ec704e4d3"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/downloads/native-package-installer-1.1.5.gem"
    sha256 "516ebbacd7382b7e424da96eda6666d60dfad4dd407245a6ad5c1ad94e803ae4"
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.14.0.gem"
    sha256 "55ca6e87ae85e944a5901dd5a6cacbb961eaaf8b8dd3901b57475665396914bb"
  end

  resource "oauth" do
    url "https://rubygems.org/downloads/oauth-1.1.0.gem"
    sha256 "38902b7f0f5ed91e858d6353f5e1e06b2c16a8aa0fd91984671eab1a1d1cddeb"
  end

  resource "oauth-tty" do
    url "https://rubygems.org/downloads/oauth-tty-1.0.5.gem"
    sha256 "34e25c307da4509d4deec266ff3690bbf42e391355f496201c029268862d8b17"
  end

  resource "pango" do
    url "https://rubygems.org/downloads/pango-3.4.9.gem"
    sha256 "976ec073cc137b7a27e3a40127a1f30ca2a016c6851fff74944dd0581362922b"
  end

  resource "pkg-config" do
    url "https://rubygems.org/downloads/pkg-config-1.5.1.gem"
    sha256 "a118ce51b935bcf3cfe1ce455d276a8e1c4b8542fe36bbec3197ef9aff15dc09"
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
    url "https://rubygems.org/downloads/public_suffix-5.0.1.gem"
    sha256 "65603917ff4ecb32f499f42c14951aeed2380054fa7fc51758fc0a8d455fe043"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
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

  resource "snaky_hash" do
    url "https://rubygems.org/downloads/snaky_hash-2.0.1.gem"
    sha256 "1ac87ec157fcfe7a460e821e0cd48ae1e6f5e3e082ab520f03f31a9259dbdc31"
  end

  resource "text" do
    url "https://rubygems.org/downloads/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "typed-array" do
    url "https://rubygems.org/downloads/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  resource "version_gem" do
    url "https://rubygems.org/downloads/version_gem-1.1.1.gem"
    sha256 "3c2da6ded29045ddcc0387e152dc634e1f0c490b7128dce0697ccc1cf0915b6c"
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
    if OS.mac?
      # TODO: Workaround for current gtk3==3.4.9 gem. Try removing when mikutter uses newer version
      # Issue ref: https://github.com/ruby-gnome/ruby-gnome/issues/1521
      %w[cairo-gobject gobject-introspection gio2 pango gtk3].each do |gem_name|
        system "bundle", "config", "build.#{gem_name}", "--with-ldflags=-Wl,-undefined,dynamic_lookup"
      end
    end
    system "bundle", "config", "build.nokogiri", "--use-system-libraries"
    system "bundle", "config", "path", lib/"mikutter/vendor"
    system "bundle", "install", "--local"

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    ruby_series = Formula["ruby@3.1"].any_installed_version.major_minor
    env = {
      DISABLE_BUNDLER_SETUP: "1",
      GEM_HOME:              HOMEBREW_PREFIX/"lib/mikutter/vendor/ruby/#{ruby_series}.0",
      GTK_PATH:              HOMEBREW_PREFIX/"lib/gtk-2.0",
    }

    (bin/"mikutter").write_env_script Formula["ruby@3.1"].opt_bin/"ruby", "#{libexec}/mikutter.rb", env
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
