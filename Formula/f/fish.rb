class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.7.1/fish-4.7.1.tar.xz"
  sha256 "6f4d5b438a6338e3f5dcda19a28261e2ece7a9b7ff97686685e6abdc31dbb7df"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0748afd7677498d11bfba25a9f207637ab4c946a7e3ef44015fafe788b49087"
    sha256 cellar: :any,                 arm64_sequoia: "72c35917c46817b8ffc7a29a88503dc1c69c480791c00d1153b3c6f080438f24"
    sha256 cellar: :any,                 arm64_sonoma:  "d2ac9381c0c31e65807936a22878482d9e55e9fb5c3cb6839d14a04638f7b595"
    sha256 cellar: :any,                 sonoma:        "99dd20315683a455a83a8bed7304b989e4cf6e374b14757bcc27a15f76efdfe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83111b56a3eb19014461ff189b9f5032fe216f5d02e197577e3eba9ecee3eae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed24872ec681dfaf8c43449bb67242f76e7b4952a678b0b6564889baabc35950"
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
