class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ee1fee20c891db567abe753de25e7f1f1d4c7c59d92b6ce28f2e96606f247828"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0cc641884533a948e74cddcae36687ab233903722c81582ddf1d365c99d67570"
    sha256 cellar: :any,                 arm64_sonoma:  "8b0a6b439ca9a9499d344241dcd3350bc14a214b3ce339662d0557db129b580a"
    sha256 cellar: :any,                 arm64_ventura: "7c0c5a7d08953e7d7a00d105a262fbd083d779dcc3a6854caf8ce268e49102e8"
    sha256 cellar: :any,                 sonoma:        "f3491dbed77e9cc3a2328492324f1061251e7576bae3f1e15d22e7d5f34b216b"
    sha256 cellar: :any,                 ventura:       "26b2779b32a9ad7511189ba6347b453cc9b98f62c96228a3832cfbe12c61d48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c13a3b4a68253847ede94468e90c00ace99cf93095f21fda7064ebc3da96d28"
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
    ENV["LANG"] = "en_US.UTF-8"
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/haiti --version")

    output = shell_output("#{bin}/haiti 12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4")
    assert_match "[JtR: raw-sha256]", output
  end
end
