class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v5.0.3",
      revision: "07e05e4ab0d3a37002fa3f5481d8eea2b6773a21"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "cb189f00717815eb7cd358d8603d4008e91cb1047dc0604d6f8f253aae1fcbcb"
    sha256 cellar: :any,                 arm64_sonoma:  "0167c167c1ac279e9735adc4864a9ab8978702a326be96bc23f0b40d93415737"
    sha256 cellar: :any,                 arm64_ventura: "4e6c68f31865a1ac339d1730878f7ccabf33c70c357e08ab4e9e9ff06890b388"
    sha256 cellar: :any,                 sonoma:        "8564ba1c4dce1b01f0d7c811eac8e293ce19d9a3a8cfe9e65f42751986526bd2"
    sha256 cellar: :any,                 ventura:       "aad512a1dae9361fb9dbae9e8b8bd8bab6e7eafe1664020987f2dab9ede03f65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "565013cb22616f165a7eaa3740f2147af27489ceb8a6b73052d4142e28cbbed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a715d7f6162abe6cc149eba6ee44f5230b42c53f8bebbd81c3cc370ae3ab0a3e"
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
