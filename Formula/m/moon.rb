class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.40.4.tar.gz"
  sha256 "473029179d606418b986ddbcda8d1f74c806e7ccd3203c22f71ff6d9bf37f61d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e35bdada996d7db8eba0eca1f33e5e51d1b29ab563b7ae6d8bddd08222ad2ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202462315c469a52a360c7c3038e19c7471f0ee97c1c7902fe5dfbd7c12bae02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fc83ab494bd1b44be1f14f27235b787900d538940d8fffe9fe761d0a110959b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b481232d314c2a50a2256704534173a906fffcff46d32c61ed5b7a37b5eebc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06db1b5fa7216f1cd9a8f70b681543f5d611c513db12b0d9f342076d4513dc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2de30ff5c357e4310ce43668cd3c3b3405c597d1dc65b2413b5cebfe909119"
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
