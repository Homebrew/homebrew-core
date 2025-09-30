class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.1.0/fish-4.1.0.tar.xz"
  sha256 "07a76c67e161b9edc772e6f1d66ebead85d7056e86631d61577f9f9a529c4d9c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_tahoe:   "83084c80c6edf20c6fbda0cf29ccf30a4a7be889bb8ce083183af8e85670a03b"
    sha256                               arm64_sequoia: "bf2b551d21e09192cc53d5cc226fc7611af08220682c0e213091f524b770facb"
    sha256                               arm64_sonoma:  "7cb3c89dc53a508412da3767e13f95061a36503e8898fd850f5a43ee13aa1088"
    sha256                               sonoma:        "1f085ebdab86ec83d4ed7b261ed1896bf10088256d5124b0643f1c2f235e9450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2634fa0101e4227f8b41c42b64588e6ea3d57715a292414c2be2e47c12d44d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e403c781a41c912c6851b5fee0ef4ea5ef70227afc90c658feed85b5b2d43d"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
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
  end
end
