class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.2.1/fish-4.2.1.tar.xz"
  sha256 "0f99222a3063377c91fbf78d9850edab7a0b91bdbed201cf79da48ea3a41f393"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81f3d22ec56e50b64673a2dd1aac3f1224a116e59a83f9074f386b90626f68bd"
    sha256 cellar: :any,                 arm64_sequoia: "46632c26e0d251497a12e586bd69670d0a030085de6c915754827f7a75c5241b"
    sha256 cellar: :any,                 arm64_sonoma:  "fa64841ba5c10513253a746473d63890855363a52e9509d0951c2618a522f9ba"
    sha256 cellar: :any,                 sonoma:        "dae5e8d1a2cdc06ef2f5322ff229fdcfd4c3cdc2cb24e3ba31c029650ba53f4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32db9b07e3426b93ed15bbd4e77f32d699e50c14b507de50ef1021e435218a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642bd9f9c853f578cd7189765260c3b82478889a021c2cb67bac5e2b1e25bbc8"
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
