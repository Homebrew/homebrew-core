class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.0.4",
      revision: "6f7a4675fdf69647f524af3facd1d55f6f221d46"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "681b4cdb963593bcb7751932ce983f5c03f61f2f263853bbded0d7903ad48f85"
    sha256 cellar: :any,                 arm64_sequoia: "2b8290b933763c4949199e2d218170fb1ff8fb3cae0a3018a8a4bccda3f3bd61"
    sha256 cellar: :any,                 arm64_sonoma:  "99430c0001d8e2b6143046da71c78e6403e140ad99938380eeb32d14cea99cba"
    sha256 cellar: :any,                 sonoma:        "9b8b1a4ea0dd4dcee609fa07c3f26b4e6e824aaf8c21defe8e622af8f04a3201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b87dba85b56514472ad6e21697259d4307f14a0ad9cb756fd12060c74c5e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5060cceb3008241c3b011f5845890dffcaf7264bc43e4c319e226041fbd61c42"
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
