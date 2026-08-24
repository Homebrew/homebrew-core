class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.1.0",
      revision: "5cefad36349e5798ab0e4e33551907ff999ccbaa"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "bf458db419e1e6824d7a37a817cb1f8c7c81ee308d799b83985699f7004249f8"
    sha256 cellar: :any, arm64_sequoia: "7e3c06e73f0ce734a57fbef409a23925b27d772f9004a3919b4b7888ac833a1a"
    sha256 cellar: :any, arm64_sonoma:  "efb54e532db76b99df76c3f9c74514429f4e7b0dbf51f44983b5519c7c082eb6"
    sha256 cellar: :any, sonoma:        "77f6ca7ced25d6cb48b645e7968f4899e0820eeb3fa5547953eb92110ba30578"
    sha256 cellar: :any, arm64_linux:   "7e50eee9470029e114665010af6c006a504eed6c429223ebcd36de38ed60a857"
    sha256 cellar: :any, x86_64_linux:  "14a2b4ea61f0503c58770ae2f041a87b63ad56b63429f721999b9818ce23a1c3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "ruby"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    # Locked rugged 1.9.0 cannot detect libgit2 1.9; remove once upstream updates Gemfile.lock
    inreplace "Gemfile.lock", "rugged (1.9.0)", "rugged (1.9.6)"

    system "bundle", "config", "set", "build.nokogiri", "--use-system-libraries"
    system "bundle", "config", "set", "build.rugged", "--use-system-libraries"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~RUBY
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    RUBY

    (testpath/".licensed.yml").write <<~YAML
      name: 'test'
      allowed:
        - mit
    YAML

    assert_match "Caching dependency records for test", shell_output("#{bin}/licensed cache")
  end
end
