class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "d0d890b91c5c1ca2deb86329413125a0c2eeae455e8ca5b69cb7fbe2266336f1"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73d7a55899abeccf6e5a67f689526e88744ef93156bdf382a71358da3002b13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30c69e7a74d1b7013d0f17dd1746a76c0a61161eba0112a70451d0d14b3b954f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13cfe10fd4be65386ee346a46149c20c4a7699fab6fa8223ec4e4a8e341b50aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e60ce9d0645b22b36f1476ef85e17097e5372562642355f7fae0b401ff5fe5"
    sha256 cellar: :any_skip_relocation, ventura:        "525599ad8bb09bfc3188312dc39cb9f6c71b6d509f1a621dec835335591f6e90"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d21e7cf4430696d2fd6dbf2c9c02b5003512de6038f2efad43a72cc5146fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2e04e5c0667d7cd9cd2bbb59256232ec6df44d27fef18d602094b453048533"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
