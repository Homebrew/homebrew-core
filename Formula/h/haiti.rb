class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://github.com/noraj/haiti/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f6b8bf21104cedda21d1cdfa9931b5f7a6049231aedba984a0e92e49123a3791"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6816ddbb4db2f5c6e84917a0ce56e7e96832aa56a68c4f17a94f529a12c9fe5d"
    sha256 cellar: :any,                 arm64_sonoma:  "91cce63fd959a495cb4b19f875156d118af052136da584628903fa12841d6e5f"
    sha256 cellar: :any,                 arm64_ventura: "ac675715ee3d7c718cb64b32dccfbf4c6c59f5903e0d6a6f7a002c826ac786dc"
    sha256 cellar: :any,                 sonoma:        "fbabec938c677d8c8ccf32ae492ada6db536f2c59ddcda7de55c3673c7ec2471"
    sha256 cellar: :any,                 ventura:       "dd1d952cd49a64a32e4cc2f825f700aee62cb2e88fcee96cb0cfa047cffe4930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc264c904ea442c908783b8d8f0630abe8718581f99eaf2e9ae34697559db61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ef3c1a86e06b06935f2cfba4b037d681d37ad589bc2196f4b882d76e933f02"
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
