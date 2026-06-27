class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.8.0/fish-4.8.0.tar.xz"
  sha256 "33af62c7df2fa553e0e84fa81f6ea48acf98c2bfc50036eaacc70ac8ba63e707"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "997643016a4e08dff753dd1e0e3ff309ddaa97cb275d6b0a3a58b6481fe81ae7"
    sha256 cellar: :any, arm64_sequoia: "42eb74c806fcd8bc9063cc4062cb33d252332cd6e5b0e38cc9e4a5282700c8d1"
    sha256 cellar: :any, arm64_sonoma:  "29df45ceb1e4661b944e4ac0cc4ee75e6e6fcf133abd06f9ce490cdd81b9390b"
    sha256 cellar: :any, sonoma:        "86fd899be4526711c7390fa832728506da964bdaf00ce3399f46ff40a757e368"
    sha256 cellar: :any, arm64_linux:   "220dd080c81fedb2bc9f96a41784c64be645035dcb6ea481c7849845eba931fa"
    sha256 cellar: :any, x86_64_linux:  "9585d0abfcb0476a1620bc79b74894e4509435267b6d903c23265bff293cbb98"
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
