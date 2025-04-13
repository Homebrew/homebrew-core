class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.0.1/fish-4.0.1.tar.xz"
  sha256 "4ed63a70207283e15cf21fc5f21db4230421e4f98d4826b5b1c8254d69c762b5"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_sequoia: "0c09f67dbf606569669b5802a03fd282c67a231c3f6e501e40fae146e011e569"
    sha256                               arm64_sonoma:  "48b500ec374d0c8b3eac85f7b7bd564d3614b30c0502734ccf641a05cb339297"
    sha256                               arm64_ventura: "d537e8a0d317a2790010808136d44925c6fbfff6851f28ace82e989a78f9721e"
    sha256                               sonoma:        "6b4cd39a87dc54c2ebedf23174c60a5165fc0c1f1768dfa736374402d7bd4a2a"
    sha256                               ventura:       "cf916fcfcb0821cd85e190bf7f974bfe155cc269e2476a757fef2307930acb1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee95c8712a8cece96025402a0c25e239c700287f0e3a5b3e58abe217cf2b0811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580f786d6a20d4cd7f604588b205d3b2e4affd93104d03e1c7ab8c6b7efe945b"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  # The library itself is not needed, but the terminfo database is
  depends_on "ncurses"
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
