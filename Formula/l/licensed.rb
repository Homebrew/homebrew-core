class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.0.4",
      revision: "6f7a4675fdf69647f524af3facd1d55f6f221d46"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee35c122a511739e183c4ebde0df39dd1a11032b66ee5a4abe86be87c9d3959a"
    sha256 cellar: :any,                 arm64_sequoia: "8372fdd8302b285179254b3375c6ccf0c3ba16a8c808cb78e851e707bfac7186"
    sha256 cellar: :any,                 arm64_sonoma:  "63831487004179f5ad0fea2b90ffdfe21f10146ee1b672c1268dc2e9d6a19a11"
    sha256 cellar: :any,                 sonoma:        "924c22137403515f8acf66c7c89a7bc47dde467d3a12d5a4c506cbe133c3327d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6abd7e8deaa295ec844a4396513cea608751b87d006c9929a68b4095465d7f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af54f112e9c2cc79bcb1d0453f2cc01f1e34de59f021e65e2eecc1538a4424b"
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
