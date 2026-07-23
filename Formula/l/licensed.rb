class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.1.0",
      revision: "5cefad36349e5798ab0e4e33551907ff999ccbaa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "12b2cddfdf4d6d8c1dc2f0ff4429d2c44dc4f2ea4dee4085fbdee5b2a76f0f5f"
    sha256 cellar: :any, arm64_sequoia: "46c79b35931c3e943ee005a4d99a2c1ccf08ce3899357c48d1f56a1af0640d8b"
    sha256 cellar: :any, arm64_sonoma:  "99109301a0936326e65ca219ebdb1cbdf8902ecd7fd35910e3478f7d18c90f5e"
    sha256 cellar: :any, sonoma:        "1bdc8956cf16cf765a198e67c9c41ef476190a95cca2b0fe10f81ed047cabe5f"
    sha256 cellar: :any, arm64_linux:   "11eb0613dcffa3a921615fdcaba762404491fb9b2a91a44aab1fa725de86be62"
    sha256 cellar: :any, x86_64_linux:  "6c613e206e9b571fc3fe0edb0f0a19f996c5745a9320caf007a35b66daeb0ef4"
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

  # TODO: Remove resource when there is a new release
  resource "rugged" do
    url "https://github.com/libgit2/rugged.git",
        tag:      "v1.9.0",
        revision: "5b28daf1fca547f875489650345bf9067e78fa25"

    # Backport fix to use brew libgit2
    patch do
      url "https://github.com/libgit2/rugged/commit/5fee507fef1a322efabceee6f938195795d90eea.patch?full_index=1"
      sha256 "4495f461391564df09ece50e7eb16bc8242af11c7a732180f9ce76e8b824e660"
    end
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    resource("rugged").stage do |r|
      system "gem", "build", "rugged.gemspec"
      system "gem", "install", "--ignore-dependencies", "rugged-#{r.version}.gem", "--", "--use-system-libraries"
    end

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
