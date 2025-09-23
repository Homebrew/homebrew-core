class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "b261f29005af531f409c24e5521a01e8951480a4d4a5fea9f7c03be89f769d7d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddcc8ef87bc249ba3a05f729b9bfb8e75af5039133bd7e99be8ad335443cddb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fe3f5e4b92dfd30ae212146476e28524cf6629396af2541152b9176f6fccb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e127950bdb1a024ee7c2eb6ac4cbb01598b065e5d4c6bc96acc67d5f0151e672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a2a10aacb4914fef7899f363cfa4e7cc7b805c30d013ca752989c9ab15bfe87"
    sha256 cellar: :any_skip_relocation, sonoma:        "81dde252563955210d4d5795e2a89fc9f33dbd31d6773244db9bfe303bc97968"
    sha256 cellar: :any_skip_relocation, ventura:       "a5403a54dc28e50244cc2196cfe3f08a1d54b2ffc4d3b99663db5703d14a1c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5498840a02b98be2647e03337521cef44d89c00006653d64ba5ff5bbbda56f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f67e1c697809cf0c1dc6365ec83456a7b97c4bbd414d236180c34cefe97a446"
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
