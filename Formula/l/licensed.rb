class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v5.0.3",
      revision: "07e05e4ab0d3a37002fa3f5481d8eea2b6773a21"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9512c527fe9a169a77f603e8a42e2f97d2b20b5ecfffb6717c035498af1b0a68"
    sha256 cellar: :any,                 arm64_sonoma:  "a307338f6f3465bf0ca55e13cd635cdbb0be759e8704a4477e75625fa688d211"
    sha256 cellar: :any,                 arm64_ventura: "26430a39ccfaa5b32322f3b8793059edf7f78403fab2f0f6ff1499f206033ee6"
    sha256 cellar: :any,                 sonoma:        "9082bb6da4377192b3faceb165b92dd07c93b05072f4a267e9b289b825ba912f"
    sha256 cellar: :any,                 ventura:       "744a822354683afaba54723d9347d77344434bb6af3cce9d4a179f135e454ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e53d24346127e6479b7f826acbf5b52e41dcf0517350dccf4b2df5f7885866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c075dd97b51a96d2e86e0e7480c368b45c8ebe55c7e4f8c2ed6fc493d4c2848"
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
