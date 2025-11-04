class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.9.1.tar.gz"
  sha256 "60942329779ba01d92532bdd3a937bfd04686693b911e6193692daee9634b4e6"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "448e26881179bf3f0f022981f67d1347c8d3161e06a4d1ad745f9769d646bbf1"
    sha256 cellar: :any,                 arm64_sequoia: "811b46222ba9c98fd2b3a151dd4242dbaa14fe6b3c1b32539740aa0ed4143406"
    sha256 cellar: :any,                 arm64_sonoma:  "6213001f424bb7679faa42135fd6d97a4fad66812c79e6001be753310868c974"
    sha256 cellar: :any,                 sonoma:        "610e13ff9a7ee7ae751855dc9ada543f44edeb0077e3083c63e8e82cfa12d79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38563a363b2664a1b9460d15020697a0800027508947d164d9bdc2e9215208dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b97dbdf95b938d559ebba67ed8f6a66993d3b17b18d026faa55cb8ec22bb96"
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
