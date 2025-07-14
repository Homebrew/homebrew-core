class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.38.5.tar.gz"
  sha256 "3bcfa56979b8b90cb85492a1fa2f6297c1e7d3d1a7bdf557085e79582a55800e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "149621cb05e270337b2f1344fdb09854f0db82979500ce956a9e1fe5de826e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3ba5ba4c86bc7b9ee54dcd8932cf9e2aad3db0de4fb4ffcf5e33992092fce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0331a36425b8283980549d19e41ab1663901e3ac5955577fdc6c20b4dabfcf98"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b4132c54971b67f25a2b947f2d730ec96395b31bf0fe0b1060a9763024230f"
    sha256 cellar: :any_skip_relocation, ventura:       "659c97adeb9b0200b6d4e727e98d763976de20058867540b26c19def64163ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9dfff93fd08ffb0183f02e999afd7dac44d7e30b4d81cebc79fc68263106dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9b8a63de08f8cf14bb33251c4d505272aa57594fc773af9f5a100bdfa04b2da"
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
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
