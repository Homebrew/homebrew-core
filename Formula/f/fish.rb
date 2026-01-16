class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.3.3/fish-4.3.3.tar.xz"
  sha256 "eba0e7d325c1d46046bb9d29434e7e0dabf7f584eb156845005d688e10b86e57"
  license "GPL-2.0-only"
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d34b7daf2be032d75c409698c5de1e3d4d9311ce980616187d102bce0e28282"
    sha256 cellar: :any,                 arm64_sequoia: "f9e7f39849c3d83468fb525a143e8312c9eb2c78bf65a7b74b53636d67d05e5e"
    sha256 cellar: :any,                 arm64_sonoma:  "53a0d4490ee76a4c1121467d6f0628eae78e33d3c8f24f51e072f1647857b763"
    sha256 cellar: :any,                 sonoma:        "16b567bb859e5098405173d94af3fdb1fc3fcb01e762b08c5c16b909f55fe3cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9313e722f564d61623248f141ed65284f1598fdf02e2b4820c153b71b8dac866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c11e2ecc0a758ca2534edf39ab90c7bb198c51738964ec26ffa235ac6f3928"
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

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end
