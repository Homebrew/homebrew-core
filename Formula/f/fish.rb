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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f7a1e3e1aade3b50016d0c9ab2b7217bad0b74e6710eb564eb8f99f42d89b540"
    sha256 cellar: :any, arm64_sequoia: "f7b956b27431b856cdbbe093e6316d77702a7b807ee19518e6074b702e4ad950"
    sha256 cellar: :any, arm64_sonoma:  "cf6cfae838dacdd0ae79e9b0d03f988c4ce7ed1d5a7c00d35f65e914c8958f38"
    sha256 cellar: :any, sonoma:        "42a04063c4c04b49141a82eef31750238a5b6d40e833db00c88a9442441a6cca"
    sha256 cellar: :any, arm64_linux:   "759ba573dd3a5687c1da187c939d13f036fb97380fab82cbde7ccaf3780114d1"
    sha256 cellar: :any, x86_64_linux:  "8143f64d4019bc79b38d5ea089f7bbbd6ac6b7e657eb1b79ed20a19362ccde59"
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

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end
