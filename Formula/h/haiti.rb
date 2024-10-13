class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ee1fee20c891db567abe753de25e7f1f1d4c7c59d92b6ce28f2e96606f247828"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "fa0a92d2a68ff948075c2bf610e4dc3d721e7b54bccf38852bf101d109b39bb6"
    sha256 cellar: :any,                 arm64_sonoma:   "b630e0baaeecbf8a0d48a8ef709f9d365ebb44d01190d7a0acb1a3f3354f7dd2"
    sha256 cellar: :any,                 arm64_ventura:  "cb9dea0523928f4364481c92dba1aecdec578dcac5104c1fa7e6e946e03928c4"
    sha256 cellar: :any,                 arm64_monterey: "b9f0b8155503ec782e57a1d73065418da594a0707027a9b504388a055efd6b56"
    sha256 cellar: :any,                 sonoma:         "a3d90fbc8e007f998d1e4caae9aa3a3db0c1157b5a9225b6bb03d4fead7509db"
    sha256 cellar: :any,                 ventura:        "3c043707acf1a26407eb2942148a3051cf91e9154e70c846e7fae715e89423b6"
    sha256 cellar: :any,                 monterey:       "38793f6eeab5f02817b672e214670a1b2292990c4fff9aa7db933e1e7413d040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "582eba154c239bff3e1a1080dec23a34e638beb975c5846a15b3248146dd92ab"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "haiti.gemspec"
    system "gem", "install", "haiti-hash-#{version}.gem"
    bin.install Dir[libexec/"bin/haiti"]
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haiti --version")

    output = shell_output("#{bin}/haiti 12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4")
    assert_match "[JtR: raw-sha256]", output
  end
end
