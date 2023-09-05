class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter-5.0.5.tar.gz", using: :homebrew_curl
  sha256 "8f8d633fedd1a05767eacbd6840c6c268dd2a47f5cf7f7a520a38c8ea869f6c2"
  license "MIT"
  head "git://mikutter.hachune.net/mikutter.git", branch: "develop"

  livecheck do
    url "https://mikutter.hachune.net/download"
    regex(/href=.*?mikutter.?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "805dd1277322aac659da0935d5ac2606e6d01f5cedff6c51227fa60f996057c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed439f50638267e078091938b175fbcdcf397ced7b5ecfb4a5deefebe470188c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57a3a7832956e6df3efecc47efa760fe7a66ef23eb2dd2a32898d315b31580a1"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a47e86634f99de1607af6c06ad23890e5007b14d36ffdbca74d4f3161579dc"
    sha256 cellar: :any_skip_relocation, monterey:       "64506fe17d20986237b5d065466073d91288a3b87219aa9a46485f7a23a9e00e"
    sha256 cellar: :any_skip_relocation, big_sur:        "335fdf0ad75b7f22988f6fc547d3ad1f43cf9429feb7d64407251d43660b065f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f3e6986f8043dd2429c32cff83dc15eebb1ef7b1d41aaba9566e912816d2c7b"
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
    url "https://rubygems.org/downloads/addressable-2.8.5.gem"
    sha256 "63f0fbcde42edf116d6da98a9437f19dd1692152f1efa3fcc4741e443c772117"
  end

  resource "atk" do
    url "https://rubygems.org/downloads/atk-4.1.7.gem"
    sha256 "4aff31c1b085c3f643232bbf86f27f61a9ececa50a8e3161a214ea6c7e6f6136"
  end

  resource "cairo" do
    url "https://rubygems.org/downloads/cairo-1.17.12.gem"
    sha256 "d19fe81c4eacba3efe0dd03e7541bb72dbbfb39625099d0e8e2993dfb7e5a8ea"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/downloads/cairo-gobject-4.1.7.gem"
    sha256 "3ad622895f2b787ce083db45aebb621809f0715d05f5957a89a081b1be1eb2ec"
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
    url "https://rubygems.org/downloads/fiddle-1.1.1.gem"
    sha256 "be49c73ad55c5a08bd6cf600e3dff5038b9095d449c7fb1eb16e648fc68a5fe8"
  end

  resource "forwardable" do
    url "https://rubygems.org/downloads/forwardable-1.3.3.gem"
    sha256 "f17df4bd6afa6f46a003217023fe5716ef88ce261f5c4cf0edbdeed6470cafac"
  end

  resource "gdk3" do
    url "https://rubygems.org/downloads/gdk3-4.1.7.gem"
    sha256 "18d41308a62bc5294bfd7d5629144a6108b27b31c8d14c377a354a868c200f64"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/downloads/gdk_pixbuf2-4.1.7.gem"
    sha256 "af6faf055259177757414a1f5cf7fd82fff2598c93d3d8e28ce8fec61cf430dd"
  end

  resource "gettext" do
    url "https://rubygems.org/downloads/gettext-3.4.1.gem"
    sha256 "de618ae3dae3580092fbbe71d7b8b6aee4e417be9198ef1dce513dff4cc277a0"
  end

  resource "gio2" do
    url "https://rubygems.org/downloads/gio2-4.1.7.gem"
    sha256 "d087a6ea5da98c149c807ced62a202a22d2d0d968d4093ba778002471a78f2be"
  end

  resource "glib2" do
    url "https://rubygems.org/downloads/glib2-4.1.7.gem"
    sha256 "f4798fd8477a9454aa6408dfb9d71f34c29abfd64b1b01b51ca05fc4a45bfca6"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/downloads/gobject-introspection-4.1.7.gem"
    sha256 "1e1aa9107aab1d657c8b96080fc3efa801acf1e8febb561801cb89b5bf93ffad"
  end

  resource "gtk3" do
    url "https://rubygems.org/downloads/gtk3-4.1.7.gem"
    sha256 "8517593ef2343b5dc587ddc2688fab28f1bbf9cc91940a92fd73753517b7b932"
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
    url "https://rubygems.org/downloads/native-package-installer-1.1.8.gem"
    sha256 "cba63fb94dfe4582759acc53b5b5a87429ec03cd7b79d2c213a92a067bea9c00"
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
    url "https://rubygems.org/downloads/pango-4.1.7.gem"
    sha256 "50c857012bf7e6c8202b913f375ee49620618c41ad3a2e8215787720c93253c1"
  end

  resource "pkg-config" do
    url "https://rubygems.org/downloads/pkg-config-1.5.2.gem"
    sha256 "fcb0df98d6571d7d1a3e25b8ebb40756d13005df19ee0fafb7a7f8ec059f3ac5"
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
    url "https://rubygems.org/downloads/public_suffix-5.0.3.gem"
    sha256 "337d475da2bd2ea1de0446751cb972ad43243b4b00aa8cf91cb904fa593d3259"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.7.1.gem"
    sha256 "af64124836fdd3c00e830703d7f873ea5deabde923f37006a39f5a5e0da16387"
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
