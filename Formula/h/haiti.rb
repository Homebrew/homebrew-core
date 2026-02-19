class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "505ae91562ad8c21e31874b77c0000fc8bf649aaf031a05b15aaa92124f2ddf2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef09a5e3923e7e0ba00693183a5668851a36f8e47e768f13a5180132800568c9"
    sha256 cellar: :any,                 arm64_sequoia: "c09ce65d5cd612629fe4ff0b7649fc42a72c0ac3d3b1e4a2941581a068d04551"
    sha256 cellar: :any,                 arm64_sonoma:  "fae6b77a4120e87608d8f8b348b911909f6add74b33de49c5f0588e65579597d"
    sha256 cellar: :any,                 sonoma:        "2da2d09fcb8c96f0c3d84a39a8fc828203e78f7481ae0d5b13ef6092fa90ffba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067e1f33aede4a03ec15b5eed62e99079e842deca55926c36671efd0286c11fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7559ce9ec6e944ce9516dfc68d0c9b19d01ad85b10604df164080ab280ba9a"
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
