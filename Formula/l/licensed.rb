class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v5.0.4",
      revision: "6f7a4675fdf69647f524af3facd1d55f6f221d46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "543bec232b40015977c4333399b598789a8f9ac60b7595ba6e7b807d03d81c67"
    sha256 cellar: :any,                 arm64_sonoma:  "3467c73fc50b835d6b2b3796690358f82dc32f32cb62a1aadcf7efe457593151"
    sha256 cellar: :any,                 arm64_ventura: "7682dce3e7873abeb6fac39d330cfbc31fa42f2624dd9f5ab61975aa593d15d1"
    sha256 cellar: :any,                 sonoma:        "3e4f67c15d5a96ca3902b719b31fd71ffe667f73ff988a76dba79f3619ef8f78"
    sha256 cellar: :any,                 ventura:       "0b4aa564d2e769211cd7cf49606b5742b31c518c2c4a4e70d00c683452e19dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698bdaab6300aac978818d9eb3df3bf2572b6bc37d5406ff0c50a279de70e421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9220f30c3818fae859fc15e013631c34d0fef0ea2bec69116b5bbc9d5eeffc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
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
