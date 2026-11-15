class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.9.3/fish-4.9.3.tar.xz"
  sha256 "20998a25f73217ddcc19f499055fd587e9912d1ad6e7109120fbcf2871f0b98c"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "fff30eb9cfc4c346addafecbd79a361078c5fc3ac3a1145336f116aa1f2dcad3"
    sha256 cellar: :any, arm64_tahoe:       "9ba271b9578b67538c408c488680b31d9e9c4cc55e2b00970913bd9b7bf91f89"
    sha256 cellar: :any, arm64_sequoia:     "e0b4f919892ab14edfb938750f65ef688e1613fae672d7f1fcaeaa6db5478a1e"
    sha256 cellar: :any, arm64_linux:       "af68b390a09718effdc4d2ac1a835375749416cb80b6d363495fbe96f942fa12"
    sha256 cellar: :any, x86_64_linux:      "679fdd4401aea3b419d4991dc7c78d30ee23a2a681864e6edc09738896641822"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  # Fix inline install code parsing with CMake 4.5.
  patch do
    url "https://github.com/chenrui333/fish-shell/commit/33502c2cc0c38ccfea820dbe364858273ef70fa8.patch?full_index=1"
    sha256 "63f6db1de990fec0d60dcb8b1365c96fa09dd39e40fd649e33358373ec3474f6"
    type :unofficial
    resolves "https://github.com/fish-shell/fish-shell/pull/13097"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DWITH_DOCS=ON
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end
