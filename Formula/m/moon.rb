class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "7f1d168b64ddc9bd86e4d4c4d6f779b1e2044a397a4726b4cd1db6364b15ba9e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0612386adf5839ae5171bef811e95ab21d20e481b2cd107b378eb68d397348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862eb2baba2ee42bd6c2189afe78d9d32b40b3b3c482bfdf8f7f3cf132280cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10d5c774ac56e6e0ac9f37f88e29db83b2e7f422964f3c27407450ee58e54c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "927b4f587c7ddf96367cb8108704c249b4967ccef29aa284b8d7b5ceaabb38bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b49edb9cbe8c10d93d54ad30365f521ccd0316a4ad06664de95f469c702b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25c0ac7518a8718eddc34f075be5ca8c4f179c1964077d4f2110f482656acdb9"
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
