class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v5.0.0",
      revision: "20ccab13f3e8738cf12543ef78da3469bf63c249"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "990ad6b8f14675784a86be75e7b9f21be512f96e9730629b25fcfe505955bdbe"
    sha256 cellar: :any,                 arm64_sonoma:  "4f6aadedd0c21c9020adefe0afe9e04a2c86a4462ce171624b25f98a61e65e52"
    sha256 cellar: :any,                 arm64_ventura: "53e1e619abf7a41e12b4577e5ad797d0a9fb9c1d7ab4cb53dd233d4bd1622619"
    sha256 cellar: :any,                 sonoma:        "17b2447ccfac484d354e9b46b36b4d800c1b342cf4109f5f1b7b8c920a3b752c"
    sha256 cellar: :any,                 ventura:       "7c0e78d953be402d8a7591fc514d38eb24dfdb6c4489e423b569c81e9825e56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6efb61e7c4ea635c3307aa38fc200af81299fedc3907fb66d33f2f2f84783626"
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

    (testpath/".licensed.yml").write <<~EOS
      name: 'test'
      allowed:
        - mit
    EOS

    assert_match "Caching dependency records for test",
                        shell_output(bin/"licensed cache")
  end
end
