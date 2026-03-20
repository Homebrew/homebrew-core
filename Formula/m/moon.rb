class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "66a0a978aa533d1d972abbf423702d608e8317e6bde2124d02b1bed50d85b703"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebed11f46a4764c280218b972add6bfd4fb1ed4c6e5e99f097f19e52fbae91b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c57b31b2f362c21056cc864c2c9d62fa230aa3241783db52624c2564411991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016f7994b70d640d46e7d90220ed93a2810d73d0c0e2ef3a2ce41ee148053cda"
    sha256 cellar: :any_skip_relocation, sonoma:        "9da0cbbd545e4fd2dd84f0fb8574aa9d7db954541e3cbc821891f327c2ff9779"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3423384d7628b2ea8344536e2d021a434e746a748a02bec195d38d9ef63e92e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c9c8750b7f16f740248c825fa6f813e1618e4823b05288bc57ba7b8fa6a202"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
