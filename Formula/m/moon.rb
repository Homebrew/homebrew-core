class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "04137bc23258427f0dca0852001582936e98c3a49ab1fa3c2837ca1389e33222"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "376caf3ce9dff45109cd6597101487cb76714a0158475b7aea435a70e6852a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b640fba38ef02c890e7b0da25d33786fa209f7a27a6e47de2dfa19c7b01ea9bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1544209d274ce25f6b3eb527d5cfc21f6214400e0a4acc16c85edc9fce3c0a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7f2d4174392deb2a4fa6e08f430dc2589bea7cf6d1cb6cc3deb97ecc4bd9e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6fc27d7fff5c3259a94dd22597e0b90cb7decec1bd8df18f4196c27fda0af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0aac5618c5cb935cdc9526e5cc636e1c3073725c282f67c5eaf9f0c3a3d79b"
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
