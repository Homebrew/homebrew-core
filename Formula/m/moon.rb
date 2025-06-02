class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "871d961afb13622e77e39d880dfa6bf5ee7d29c02dbcc50af7094d2144bf8bdf"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6835c65038d8f110665cc510a089cb580073c5226e4058deaea623b5285ccfd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "202eca6cd1677c16554fe11e34430eabfa87dd2545f1b8744f9b21cd508eb439"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f7b6ec578845e25cfbce2567f22635ecdc12906f997e1126284c6f7e05c3120"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c829c0f7c21bc2da48abdae67d69677232a615281d5d7d20858274a975a2980"
    sha256 cellar: :any_skip_relocation, ventura:       "46f8be59a44dd93b910b7abc8991db88b352c1e4268f0e1e236347a867195f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b6bc6abd43d1e08fad12e6e09f33152505613e124fa76d84bf75bffc13bee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8622ab460db6038ccaee2d58703eb3e351fb6a36ea1d715c1c0ad7f02b732bac"
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
