class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v5.0.1",
      revision: "d74f3bcf74c241eb79b9b82d7ae3d4bad22bc791"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff62a265e124b6dfa61060017d0ec1c861083f2dcada89e8b08bab249575288b"
    sha256 cellar: :any,                 arm64_sonoma:  "77d2b90ddeb1201923133997788dc353e87815d3b32f6de90ecf1e87b88d672b"
    sha256 cellar: :any,                 arm64_ventura: "13556d3679589482caaeb4d7c3073583447a9a0123cebbaec555e4449f67d5e0"
    sha256 cellar: :any,                 sonoma:        "46eeb6cb7f8eb7e815b2ee960608945c988e539064e866929b1541a279117804"
    sha256 cellar: :any,                 ventura:       "0f12df0a2caf888b9b35102c87d98d4c493147c5628f7dbc9b18d4814418f119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee93a8cb1c187dfbaeb94dab3ebe70157d14360a3b93f88c8187f315e3f61f9"
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
