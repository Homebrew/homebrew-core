class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.0.8/fish-4.0.8.tar.xz"
  sha256 "7f779d13aa55d2fa3afc17364c61ab9edc16faa1eac5851badeffb4e73692240"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_tahoe:   "1bb0510acca591dcdf4c28b5ee3e3adf8ca6edff2c68631e29a045bc1dfa484f"
    sha256                               arm64_sequoia: "2efe4da65c4b83b119cc4ff5e93e9dd6967cc5d2b39fa55bf614412c3b15cff7"
    sha256                               arm64_sonoma:  "5093269dfc262c2eecb45ab756bc80f39287f2482fe00202c26a80559bb9fc39"
    sha256                               sonoma:        "dcaeb02459e18a2632c2bd9af26f111ee384f8a2938f03f6090c902b224ffe79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "536115dc6c47b7b96a74e347cf86f2dabe5f9010fc2d72b820baa6e9965481f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09aed332aa2f535d7a98c98d3bda5705e960444affb138e8337830bf6d0233a0"
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
