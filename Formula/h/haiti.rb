class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f6b8bf21104cedda21d1cdfa9931b5f7a6049231aedba984a0e92e49123a3791"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "437a900ef99a2a9ce151f54852b5ceba54b04b0ae4f7dbdfca33ac96262db51c"
    sha256 cellar: :any,                 arm64_sonoma:  "d256b2ab7188e82c043c22fc4ca8e5df092d581e4d0c7db6a1feda3110a3054e"
    sha256 cellar: :any,                 arm64_ventura: "cd3f25be3ff7e82d716d0c04b6703687a104014703d0fca01ef6b743014a1112"
    sha256 cellar: :any,                 sonoma:        "03b15c6432552b2f1bf9b501292dec5d9981c1b31e48b371c5368248bd3c9498"
    sha256 cellar: :any,                 ventura:       "eacc0e910d7028495d5ac2dd6fc488fef97f660bd586ab4f4638d90ca9830345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ba6681ea727c139e302ef47608117ceba1ec44781fd0f37ba9eb646cfa3acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1cab0eaadd053425ec6af959b808b9b8c60f12e531791ec6215cf009529e33"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-hash-#{version}.gem"

    bin.install Dir[libexec/"bin/#{name}"]
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
