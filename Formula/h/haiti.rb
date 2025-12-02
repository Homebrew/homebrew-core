class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f6b8bf21104cedda21d1cdfa9931b5f7a6049231aedba984a0e92e49123a3791"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "13b48fd2a1dd6cc4204ad1c00733a604ca0515d8f3139206b6f98c08d0fa8377"
    sha256 cellar: :any,                 arm64_sequoia: "7411eadde72e740156cef4aacaed4a454bb2dbc956624e0bc5a8cd263ff74575"
    sha256 cellar: :any,                 arm64_sonoma:  "21163fe9aa22b82cad01e8fe134c46defa97b35bafffd4724d4e930d30313aee"
    sha256 cellar: :any,                 sonoma:        "1ca996eee260a6e729bc8b99cd1274c1c7e518bb305765c0a6686f1d6051fca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56fb594b6e92322b2bb6294c40b8d7a5fbe140324b72eb20a5e4aaac85e5d577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11c569349cc73a9344dfbe7b6110a1a3951fa8f0dbe0e9685b7528cb235f57a"
  end

  depends_on "rust" => :build # for commonmarker
  depends_on "ruby"

  uses_from_macos "llvm" # for libclang

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec
    ENV["RB_SYS_FORCE_INSTALL_RUST_TOOLCHAIN"] = "false" # Avoid installing rustup

    # commonmarker fails to build with parallel jobs
    ENV.deparallelize { system "bundle", "install" }
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
