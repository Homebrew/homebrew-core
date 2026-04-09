class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.0.6",
      revision: "30a7f6abb2b1ba6d960f2878233009766430e085"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c88684d9683431a42b1fab8b4be83c95b5699cb571383d58e44c295342b56ae9"
    sha256 cellar: :any,                 arm64_sequoia: "ad97635e2a83084e400112444db2f5674af5ce2f3c91ca2bb9f235147858756a"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bf2af64ef09eb7278ce260ada09b6ffc001c77dcc46c89f24c5540bb6bee68"
    sha256 cellar: :any,                 sonoma:        "a15d6aae872eeea77f0099b0fa5dd410058779396a2327db4c5591990d79de93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59ae55e6198311fc0186cca96569da692ddd305bfeb939791eb2c8da952b3e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f03ed2f11a7cdb3a2bf05b2670004612b42717b2cc9073753eb8ac3da7d9c860"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    shims_references = Dir[
      libexec/"extensions/**/rugged-*/gem_make.out",
      libexec/"extensions/**/rugged-*/mkmf.log",
      libexec/"gems/rugged-*/vendor/libgit2/build/CMakeCache.txt",
      libexec/"gems/rugged-*/vendor/libgit2/build/**/CMakeFiles/**/*",
    ].select { |f| File.file? f }
    inreplace shims_references,
              Superenv.shims_path.to_s,
              "<**Reference to the Homebrew shims directory**>",
              audit_result: false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath/".licensed.yml").write <<~YAML
      name: 'test'
      allowed:
        - mit
    YAML

    assert_match "Caching dependency records for test", shell_output("#{bin}/licensed cache")
  end
end
