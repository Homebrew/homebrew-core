class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.2.2/fish-3.2.2.tar.xz"
  sha256 "5944da1a8893d11b0828a4fd9136ee174549daffb3d0adfdd8917856fe6b4009"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f43a181738a3c32a204606ca1795a80e5c1cf60c0944a2fc7ac7cfda5fd1696e"
    sha256 cellar: :any, big_sur:       "81df0f00e919fbdd42ab36fbb13bc7c5eca27b6c3c085a525db6e3f18d03775d"
    sha256 cellar: :any, catalina:      "2d6e8210d1ebfc5e06c0e73294df22adc6607bd5980d26e59ddeba9d3fca8d6b"
    sha256 cellar: :any, mojave:        "862fac70a5d143b7ac017f9d6b13f899bd6944f41fde25e8e31de4c70393b387"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
