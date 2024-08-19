class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "v4.5.0",
      revision: "b83dac625d37b9e5c5151569b011be2a57816e38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4b7ad01ee7de55961e95f82b808d2bba758459c8fb79d768df1d9489941223a"
    sha256 cellar: :any,                 arm64_ventura:  "2f4b5e92a768349a8167efc94cbe602be17c7af4899cc827c534107bf336b18c"
    sha256 cellar: :any,                 arm64_monterey: "25fac47c545d7442c1d7b4aba19cca2b6d103ec7e09c17565ac7eaf32cfd4b17"
    sha256 cellar: :any,                 sonoma:         "ebc8d31605c467416f0a693bb3214dff84948b0788d00f9a19c7ffb18bd89366"
    sha256 cellar: :any,                 ventura:        "23a1d65eafe0f8902da4ebe265d9d81de979f53a0818233dad818922f95fcc94"
    sha256 cellar: :any,                 monterey:       "d1ba0b84009f3ff750e71a2acccfd54583223b53275e991f993aca29ea1abe48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216517ba4f2526dc918c7c5350a068b59ceb876c7c8b4fa1eea14038976e3c43"
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
