class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.10.0.tar.gz"
  sha256 "8309c720ffa76c6588c5bc8f8dc169b6633059a9d8d68cb75cc8488667d81c01"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "550ef54a29d20b3e71cd5a2b9d557919152369dac8a4d2dc962fe8a044d0898e"
    sha256 cellar: :any,                 arm64_sequoia: "337cb4234cb6d861f02862fd393372b18405aa904c3589b9e6161c017551b4b8"
    sha256 cellar: :any,                 arm64_sonoma:  "92fe261089fb4925d0229e07e85a3d70cbe1fb25e57e91da6bbd67dc2cb7bc33"
    sha256 cellar: :any,                 sonoma:        "1ee62850abad8485e5327ec0579d30f24fb884e773eef673dab7b36c01564f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c3a23a3d8a2e3b19b636939a182bd3da1a01d065674637d8589cbda09cc2cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68f0537ef47c062571f77b1a5b6e7ca55b0d318ca5ad7d3f303c51fc608a5af"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadfinder version")

    assert_match "Task completed", shell_output("#{bin}/deadfinder url https://brew.sh")
  end
end
