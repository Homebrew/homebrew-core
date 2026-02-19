class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.0.4",
      revision: "6f7a4675fdf69647f524af3facd1d55f6f221d46"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d8cbf6f9ebfad3fff41d1ab9f4f221e2a75f2193c1775233c6a1ddbc78cc38e1"
    sha256 cellar: :any,                 arm64_sequoia: "3c958df711d2f6ddcf6eefd4c2a7b777358aa4c8b56dba96e312d8a7cf3a8e67"
    sha256 cellar: :any,                 arm64_sonoma:  "ad142e1414f120332b7c5ca4faf63f6a1a13739c35e09d68f4160d497eafb565"
    sha256 cellar: :any,                 sonoma:        "153ff0e623b39434ef063fb328ea87cea3b173cf88fb44cc1f63c5f7bf5fb599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b305bea5e08d008c225732562742339c7e80d06c5d774f7a54a3e14401c2e109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386614c73378360866a57ff53df5a67415318e8669b483aee84a48af37ac6a24"
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
