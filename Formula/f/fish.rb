class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.6.0/fish-4.6.0.tar.xz"
  sha256 "fc9165f733a0e28a3dba11c9b1a286bc88a853f152a6694cd993512a2f1761aa"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94fe41e0661a3194d12d33e5af9a7ddf75ca8c39d45a3492189ca57b444b7257"
    sha256 cellar: :any,                 arm64_sequoia: "e3eb0ab6e9a24cb2b1a1a973ee0120a8168e03805cc614804af0d7a3ec0c09fe"
    sha256 cellar: :any,                 arm64_sonoma:  "98af27d2566d805e8675d360cffe9a97efadcc43ea5529be883199fd3896bf44"
    sha256 cellar: :any,                 sonoma:        "577c2ba5dea7dca57e66e22daaf4e867ec4be32838adccbaf15651865c59ac1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76cfde2b9fe36c516bd04e71bfb626ed0ce4da1c9db2bb129b98cf6718993c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fad48e08956993a287d1c045eb8b9d81da278677dfd06cc24c7de6b3ccba263"
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
