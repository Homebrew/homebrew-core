class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "0e423c6740cfc105b5bb262399ae2c83bce04c8753c837291f38ffdbb24ce84e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4af8be40c03653ffafbb5cc2253bfb1d8f5a103de92943f53cd3f862c326c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f551076da2363fc70ae4435e06c8ee9cde4935c0531fd78d8df636c2efeca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb7e7e7da9a8be64e7a9bf6fe6b4df49a6c2770a0c0f6e2ce57dd1c2781acf8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f41781d4738867b10bb809a821fff26b956f2edad64cde01a9c857c31bd4c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ae96aff4414dfeab1ceaba2b8e356b5512bfcb34a8c1016fd93dea942d9e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660354f054e35adcc1c22e0aaea401f409a0301b46e8137a648a4b3d1424107b"
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
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
