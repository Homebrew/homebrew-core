class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/licensee/licensed"
  url "https://github.com/licensee/licensed.git",
      tag:      "v5.1.0",
      revision: "5cefad36349e5798ab0e4e33551907ff999ccbaa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea77d11cb8ea2da19a84ab0f0364879377e11d303aa963d0ac049bf1703cbbd5"
    sha256 cellar: :any,                 arm64_sequoia: "82a43ae41ae886071174c26305626fcbd3d73345e84dc834640c66d5aedc6d8e"
    sha256 cellar: :any,                 arm64_sonoma:  "c4956552d915a6d6e92587842fdaea142c15bbaba25e90bb938829a6b1893cad"
    sha256 cellar: :any,                 sonoma:        "7af95dd4e135fca493ff97db9ff2a7deeef984d9a978b3f3556e7e3cb7a69695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f68d0c9c90ba091329670f3c55db2dab668310c0706bc549cb4ddd4a1ac484b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f587002eec90446e70bfacce15a00a64481313940db75c5cf5cb983271e3aa36"
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
