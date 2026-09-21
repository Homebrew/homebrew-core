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
    sha256 cellar: :any, arm64_golden_gate: "178bdd28d5b888253d95cd9f09749ec5b0786e38ffb2b29c5e9c883d0eba5434"
    sha256 cellar: :any, arm64_tahoe:       "c530bd62ac9277e7e1ae3de9ff5e0a83fdb5f49d39f456ce8f61dce6f56dd8c3"
    sha256 cellar: :any, arm64_sequoia:     "bfea5c0b0764de2965bb201d2803d51e6f898da0253c2e5934fc0db1333a0543"
    sha256 cellar: :any, arm64_sonoma:      "9ce8b1dc8f20c724221dd3c351355c8a306edfef30d292401cb4fc9d67c0d90b"
    sha256 cellar: :any, arm64_linux:       "101c8ae43f26503c872bfde4cabc3388ad7078304c7572e9ffb4fbd29bea5a77"
    sha256 cellar: :any, x86_64_linux:      "0660e70e2312ebf32bf858e89842efc511a475b88f292aeadca90f4893186975"
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
