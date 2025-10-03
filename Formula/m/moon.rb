class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "4b23668ae7f98a5555dd774585d1ed04819a89f90f6a7887cd41b68d5c0ca5f7"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "892497b15c2056e63d94f8781a43c693f45e59a20cd6c735e327ecdcc83cd8e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52fe439581b678e7f790e179d32b54851f59f46598abcde47cbbaf433e8f1293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7346efb189cd7570bb14f8d1693d95565889c1f6f260d12d2d4862da89108d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7da0fec68723760990f2f7653c46a440eac32a117e750b2d16ea011349c9dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efffd1a13c90095387cad035815e68619d63b0042faa2fd33069163d6e53b5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4544b9bad8fdc2a0d4dad551962869ec09ef3de1b429f27e47bbd934714dbc"
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
