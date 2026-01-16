class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.10.0.tar.gz"
  sha256 "8309c720ffa76c6588c5bc8f8dc169b6633059a9d8d68cb75cc8488667d81c01"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16bda27518c67963187cbf3e02885836e78ee3ab17d65f2da4cef4649e422dba"
    sha256 cellar: :any,                 arm64_sequoia: "74df74b31f0ada58abad5f04c1ad388637a11985bdd6bf5334892e14bd530cb4"
    sha256 cellar: :any,                 arm64_sonoma:  "f072d90102f04bd6e2c58fffe8092f631c05f799529836a489106c8928e596ad"
    sha256 cellar: :any,                 sonoma:        "58f600effe963652e5b1a8728756f8cb4f569c24e81317bc58df4fefd2225450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc0fc3a591571d5b1ad2103ebe18d7faf57e4e1784b52684606af0187159fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "668e513fa6afb8939fa8f1401c024a63b9838ac77a25c5336b446bff2d6cabc0"
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
