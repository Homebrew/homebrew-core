class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.9.1.tar.gz"
  sha256 "60942329779ba01d92532bdd3a937bfd04686693b911e6193692daee9634b4e6"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "405a1f49dbe8d3101c7d0d6a3b71803da32ec85e23440ca7e354e9f88fe83ea0"
    sha256 cellar: :any,                 arm64_sequoia: "3c3dd5a28a69643ee39a068a28dc303cacc79952af85ea8ba66a0566e1f14f0e"
    sha256 cellar: :any,                 arm64_sonoma:  "9b84e34ab45600a1e11e7b980724176d931aedf78a80751e1170f65086ddf3fa"
    sha256 cellar: :any,                 sonoma:        "180f24a6929595f8fb8d6eb090c3d23fd2188228a2c80fcc9798944690bc930e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bb304f102df86cbf940c57ce5d82e9bc1129d39e8d5232fbe0366275c5772e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e375f6d6d7a9df923f4b98bc89b013cf5eac285cdc9b10b9919430af80c1fbd"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

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
