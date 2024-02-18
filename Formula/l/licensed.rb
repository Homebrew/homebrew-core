class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "4.4.0",
      revision: "0f5e5a1d289665e8a3d7133cba6c6f3a15359ecb"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b06b95564adc540d4aafc43a2a46168771d2e6b3a748b2c95cc71a79b28b4047"
    sha256 cellar: :any,                 arm64_ventura:  "133d5a34b52686ea4625c9603e3186b3d85fc899dec2a8fc3e8c081554710806"
    sha256 cellar: :any,                 arm64_monterey: "adddccc7895034261c83e2118b66350c17f91cdcc76474149dba1f1505feb299"
    sha256 cellar: :any,                 sonoma:         "a44f7dd570c1ecd7552ced29e76ffcf3e8158b109f767b82c9c793f0451741b9"
    sha256 cellar: :any,                 ventura:        "6e06f31113b06e5ccaa02383fc07d4830dcb03b3d1555e0adccb1a32370948a5"
    sha256 cellar: :any,                 monterey:       "2118b973e3ce647acfb3b1f71f7c51a01e6de9b3f6cc02591cd29183c888e50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159f68bb6f915b6b3c1cdafe24b8f3c304149b70dc508dc3945ece03120019a7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "licensed.gemspec"
    system "gem", "install", "licensed-#{version}.gem"
    bin.install libexec/"bin/licensed"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    shims_references = Dir[
      libexec/"extensions/**/rugged-*/gem_make.out",
      libexec/"extensions/**/rugged-*/mkmf.log",
      libexec/"gems/rugged-*/vendor/libgit2/build/CMakeCache.txt",
      libexec/"gems/rugged-*/vendor/libgit2/build/**/CMakeFiles/**/*",
    ].select { |f| File.file? f }
    inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath/".licensed.yml").write <<~EOS
      name: 'test'
      allowed:
        - mit
    EOS

    assert_match "Caching dependency records for test",
                        shell_output(bin/"licensed cache")
  end
end
