class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.9.1.tar.gz"
  sha256 "60942329779ba01d92532bdd3a937bfd04686693b911e6193692daee9634b4e6"
  license "MIT"
  revision 1
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1196ba7f69fa9a76f88885d99e4d5fa64075abbe0f6c89a4c2bb52989197d564"
    sha256 cellar: :any,                 arm64_sequoia: "0785938ab4601e4c8371a92312db832f87987c81222eb739c54d943ecd7c8deb"
    sha256 cellar: :any,                 arm64_sonoma:  "55e3dfeaebcc4fcef7a89bccdfea2b6f7992b9a42efd534bd6f2e76a463493c0"
    sha256 cellar: :any,                 sonoma:        "defe5253cc1e6191ffe124ac210238638d4045a0d2d3c3d091871107ad571daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b94db3d53d160760d22898af2ba63d16585acf50382f38de0b98bd36ab58f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7ca7f45309f8d124e6da42cabcdf6358fd4cc149d95f03aa88a712d83654a7"
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
