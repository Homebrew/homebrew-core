class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "401cd6370e81fe9d18e0fa2e4a942e6afc6b7e63f1465120508ed2088b780572"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d840d835a738ed4b4605f3b0ffbfdef181a892fd90be66401008881522d0c64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93f125856ecbfb0d48ea9633a16caccbef0a3b26f0edc1ee6498b717089cdb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d5198805bd8e59a4cef435aad3c37bdeee78f85fc92ceed770cbef0168ba550"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6a1f761e065f44e49a64d56e3df5171d717bbda43a195dc509fb5e280f3389"
    sha256 cellar: :any_skip_relocation, ventura:       "49e9d6e34df63ec24256627488877eece94a48b1a7da68fd20678d947959a954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "645ddeebbb616760476a6216851c926d8a4b1d5219ea592eb12ba7dbbc559d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706c2abc4fc3d6d2a18d91831a3bae9da9a794c7a35277b13d8c86959e95087f"
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
    system bin/"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
