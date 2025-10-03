class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.1.1/fish-4.1.1.tar.xz"
  sha256 "aaf567cac98aa92fed9db3280801e2de45306169c8915e0fff1a61c07e56d2c1"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_tahoe:   "181f554cf645a14ced8cfb132482150d9767ee44bdcb8e537210b6d77515f9bf"
    sha256                               arm64_sequoia: "274cf8f4ebfe8292e82451469fafa79ff7d3c6fc3aedc3f773990cd2b8d2a7f0"
    sha256                               arm64_sonoma:  "2523567751c783b9ae703b4ab6e04c5b83af7943cc99881841be083aef43b9b2"
    sha256                               sonoma:        "5dd8d7a0f49fccd4a54ada22b4b0c500c9915c162091fad8a537625060d3fc0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33aa9d7a8feed55378a8422b56e26c27cf9ac78073880897387986457cccc438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34ad1eda5dccd6c753cfe0ad065c08d59939a27ed6280a00880d1cc8eccc407"
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
