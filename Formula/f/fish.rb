class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.5.0/fish-4.5.0.tar.xz"
  sha256 "89151f8cf14b634e080226fe696f9ce7d4d153c77629996ca4431c80482c64ed"
  license "GPL-2.0-only"
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca0dac85935f3c832187630e9b90abbad901f7477c7e7e7891e20eb026394479"
    sha256 cellar: :any,                 arm64_sequoia: "dc90500f469587f4fc42cc4cb5d6e8d259712bf104c756b7dcb47389ff4bc92f"
    sha256 cellar: :any,                 arm64_sonoma:  "7901a821b39bfe9b7ffd16305a17723aa265ec09d840111499e9b85e255ed3ef"
    sha256 cellar: :any,                 sonoma:        "b3a54aa70246afdd7ea22a0fa7b86b12532a331a070740a4afe29b403b6e8bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac9b7c0a93b06f92e4cf8b000f4550384b2ab925481cbcefcdc975f218fd602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10a173e178a917d732ec1f952f012d5e73e1bf4e44de97c6630ea2a861125fd"
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
