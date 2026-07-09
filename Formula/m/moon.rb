class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "25adf928b62ffe5734b8a015979b46d9bd49409e03f42931d707182f1feb3e47"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1f38ad8b9236ca8884724147f755d02be52c8ddc57617865bbb0d389f1b6168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a3d7a894c1236783cf0b00a286c8d8ecca29050e1708146f14476544430d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc364e73c76b791a3d4b82372b8e598c8a8e228bc10f003b0b6fcd4359d6f519"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa965e8b55e68a639f89e91dd2d9293bcf104e4cb3b2c2b1d83ae73f969ee79b"
    sha256 cellar: :any,                 arm64_linux:   "0ade4e83010d951f3e79fcccbbbea4da9373408a9237f53a26cbe1b9db876764"
    sha256 cellar: :any,                 x86_64_linux:  "61eabd3b5a4b949a780a25687751ce48eb8ae615118a7b1ecbb7ef9f97126003"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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
