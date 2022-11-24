class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.1.tar.gz"
  sha256 "2d80f0243d70a3563c48644dd3567519c32a733fb5d20f1161fd5d9f8e6e9146"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "31304a37561e0140a1bc7da275e43ca62dd747436b9ebc9da11a6f6178149324"
    sha256 cellar: :any,                 arm64_monterey: "0b5f3f982e6c8ff957f8c79c3fa4f080a32c371122511a915ddc266c4756d918"
    sha256 cellar: :any,                 arm64_big_sur:  "81a62854e98ce8417cfcd50f7036e92066bc5066bc30ab52f77de329a5e4ec58"
    sha256 cellar: :any,                 ventura:        "605882e4a0386caf9430787de530565dce8a30549274e269fc4f7444a740dd41"
    sha256 cellar: :any,                 monterey:       "55df1e0b7ed0ff17f9458f75e0ca852ce8248869a3c1d4801cecc110ef7b7696"
    sha256 cellar: :any,                 big_sur:        "02efc80dd1f83fa7ca4b4b595d50e3b572bbb03feec64b5897fa7303e6642fcf"
    sha256 cellar: :any,                 catalina:       "4f51184aba9bbe9e5d5cd6eeb1e69bfa9d61619987e7d10959c403735738b155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22c52e9bc43551ed3b40c302784a271aa82db6d3ad86634d4fe165810f1935f"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end
