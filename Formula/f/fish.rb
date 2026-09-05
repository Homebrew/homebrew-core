class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.9.1/fish-4.9.1.tar.xz"
  sha256 "93400374bfdb73215cae43bdb09c724f1653f439a85dfc1fe2866639046c95f6"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "781ad2db83ff66b3b6e5151a86bf7bf64601879f4d949b025b2af68c0efbab17"
    sha256 cellar: :any, arm64_sequoia: "444b3b520089122e0eef85dc39f96f390be6a8729a94fc84c6342bcf1eb5fe93"
    sha256 cellar: :any, arm64_sonoma:  "8cb010bab387290f2e05715ce5f0664c6d5c8482e154a1664014182e76d0c0f1"
    sha256 cellar: :any, arm64_linux:   "ca3034132d32b877874cb922bd466bab8fec2b274070e4ca19eeafea2b92d9e1"
    sha256 cellar: :any, x86_64_linux:  "a395de95d0e41b75364d8d19d87c43ea34b6a018f951ccb7d9a9f931579cadf2"
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
