class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "af1091a1813e41869075dea77e180196b4c45bf0f4d8ef9aa7ba5a07df0377de"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "591adbe01890eb31dfe7e6e2a9d46a74d659ab7d03a80e82404a48dca9481aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ef648593ff9c23033a395137b89260d7c19a9d1bbc31fdabd7b1c886e58bb4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e95215b45427226dda81899a617474264f9a21143925538cb9e941c92df200f"
    sha256 cellar: :any_skip_relocation, sonoma:         "25d2e744cb748c6440323b43a16c0d4deb4667073eb3d19e23eeaf0be84afdfb"
    sha256 cellar: :any_skip_relocation, ventura:        "2dd823614220ab68b5fa009c142a6de49ced9ea002c3c878e1499058e1e4bb7b"
    sha256 cellar: :any_skip_relocation, monterey:       "20fc9b5156eedb54337ebf12277dd26ce0fe75e12159448343d5f2422f93195e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc23eb8c8a1ce747ab53f4e17cf9f600e7861ba6fbf69953626554227c54d16"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
