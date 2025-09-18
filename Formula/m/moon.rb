class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.40.3.tar.gz"
  sha256 "4980c8059e22b69e76f67652b6959efc1f8aff4576dee3bf6f5d8c2e8a2d822b"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af47cb3cafcbc10d7594283dbbf2abf50bed693d06d0361fc8d083050c2fc73f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d46433cdbb287e260a103124765349cda8dae846d228b970b97f70b85867e3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a9ff0a981dc7cbfcedae798e4c573fffcb5a096939745f193ca682b72fe2b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8aaec0568cd1856e9332de1f53f3a59a68f7bf78ea1677963aab90e570d247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d731be1d99639e0979f99ea111e974192a61ed135b1328d510e81ceed92ffc69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181f359ee424cdae251a5c95aecff929464624f3ca44b307ca32f50f206fd77b"
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
