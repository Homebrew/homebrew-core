class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "f82a4bbfb3012b4d0bddd3b29d7e343e2b8fa96fbbdf125d1379623c6091269f"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46fd10d6dc7f7cfdd05334c17d14bcc0e3ec7f17cd042461df487c81b22cec7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464c2a34a92efe6b902285709383d71c78503a308642f25d79dc58e3c6bc0683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2c257570096a901d44b966ebbd1e436ccc2b3992731514db0cbcac422ce5ee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ac863e68b7d3e1a19bdb4343a687b446e2209abbe83b2f4556199268f872e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0978ae3304e9971a672ee803949a77dee7a05e4b1338b9e6de42ba3852fbc2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a95c7e5f0ef82da24a8d49424b7533ba8946390b5a614a9373a1286d8536203"
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
