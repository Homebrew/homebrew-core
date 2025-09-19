class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.9.0.tar.gz"
  sha256 "79e0d4a6ff654bf47e11f0f2f4c2b48abe95fc1d4a7637fbefc3013775acc05d"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eef05933df754b4189b70a78cbdf5903db5f9039ce7040dda05dee8e16cccc21"
    sha256 cellar: :any,                 arm64_sequoia: "e606caf8153c323cc5b252b72926dd05d2a9932a86cfe42aa6574acf403a7edd"
    sha256 cellar: :any,                 arm64_sonoma:  "ed4b65081b9d9da4ad0dfcbcaa66441d49fd2d21686d7f65c969fc80f70d4db7"
    sha256 cellar: :any,                 sonoma:        "d5536721ca1d3442dc1a0193e3ba438feba366231b4fb12be82f710fe7db82c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfadf60e78598c3f108505d90839888a8213a7e90b386fedb63ce53ee2c8c909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ea8d9c8bcbdf23e6131090e3cc12288e2a0d7a26fcd8ef9f36df33dbc65bf1"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
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
