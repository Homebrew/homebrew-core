class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.41.7.tar.gz"
  sha256 "0fc7c603f30e21c4c4ee8d07b1da1b61f0c4722c5406728c1493db46fce597ab"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29eafea7eeb9d9870cab4f05b3919e0c2bcac4098c2ca334b88d63dac89ec0c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa795f733b80b20922baa1412d27d630e5be03c278beb9363e3a0f61783d3166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7e4f593681e4e7e660c92c9c60db1b82677c3b457fe34d04c66bbc5a1178ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7e43f256e1f114f1503d971c1747054d59b08dff33389959642de375f69cb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025b8db24f5b441eb39c9ef623e27ab1d312a2765127ab6be01733421b57b359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a405f88f5537a3755b67e45f7b24eed33850ef2fe0bd287eaf93510c333103"
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
