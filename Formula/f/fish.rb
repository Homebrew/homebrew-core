class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.8.1/fish-4.8.1.tar.xz"
  sha256 "0eb86a851e865e934a7c2091a73d7695225e78f0e00a7bb96d5f877d76c65782"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aca649fa38eeb9e45928c0629942bfaf83bb31e42fe79194f2f38aabd3f4a8ad"
    sha256 cellar: :any, arm64_sequoia: "85606c0bca9b1423e2482285ff209dc6cc9dcc9a314a6d416ab4ffbc33ae9708"
    sha256 cellar: :any, arm64_sonoma:  "bb51ea86a6b1162b86a49d41e5b1eb9738ce3537f3fb7cdfe90f9843e7d613d5"
    sha256 cellar: :any, sonoma:        "3bc7ec406877d60f952c276c8826c8df0bbedb9c677336e32c6341444163de5b"
    sha256 cellar: :any, arm64_linux:   "4efff2ff60ec41692b0fe6be2c36bc0c5e2525c57bb1a980b81446ed225c8801"
    sha256 cellar: :any, x86_64_linux:  "cd1d5a4e14b47b287365bea22b27b925bf33ce8060166b25b86f31c353cc35f6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DWITH_DOCS=ON",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end
