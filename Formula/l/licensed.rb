class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "4.4.0",
      revision: "0f5e5a1d289665e8a3d7133cba6c6f3a15359ecb"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54fbd16be413d08aefb68c8e2da419e049cb25822c4bb6bb7425f0965ee9cdc2"
    sha256 cellar: :any,                 arm64_ventura:  "42962a11a86fa902c5ddddde928328bac878a0e127cdef2031a3c0f461070ffe"
    sha256 cellar: :any,                 arm64_monterey: "6dcc00f39ac67cc2e095bfef934e42490ce3052e87d824fc1ddeadc3b16116d1"
    sha256 cellar: :any,                 sonoma:         "73b6e7671b018756f0905d3bc3dd7103d78b80442fb2142f1058c9c4ff7040c0"
    sha256 cellar: :any,                 ventura:        "b6a5726950e9f40b2ec10ea7b6906781669febec5af852aa06c028b946eb80b9"
    sha256 cellar: :any,                 monterey:       "ba4aa222030a9f46293f227e40b02c268926cd041c6778efd76b17266beea2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50294dc0e6808dc31de6f3c7ac1c062c99d71465e02ca0bf822d9b0586fd1b3"
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
