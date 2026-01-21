class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.41.8.tar.gz"
  sha256 "ff308cc372fa8a161fdd0ff55766c763d2114fb41f47bb11990a56c84b6f769e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f80dce15c1166b85ef7b4cb567eba32469d18b730427678bb0cc42575bdb6fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9002136205625510e6c4490a2065d55974c697c2304617232fc19a4e336cf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264fdcf210c8ed446d9ca772cfc7659a96f0f766c573e847501c72658cba2bc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f8a16f77472ff6c28261d760cb61e38015fef9d8e47238199e7707125eddcd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc282b8ec3738d5841e83c6995401227453bb7328c969d02b68ee083f529c33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c040a6f788e750a2ee28b3b8950fc538484416bcb27751e045f3a776b7c4761a"
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
