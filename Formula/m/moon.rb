class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "bb657d10b2be7fafb75eefe62ac5a88b6a4437c96aeb83aee67865aac1d7eb14"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58151bbf21ce778286f5a54d82422378badf28cc2ab706d4c35d328c70c1ae81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "751f22d3d5090dc47753135ac6f0533dcc246826b5c543c350ead4b283b091f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249a15b36b1cef568b0c2ee06738c1d9b0501767f92bd4b3b36e9fcfc98a02a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "351733a9c37d2e1f8aea17162b0dffb61f00b6c0b97ff9d35b66f8ae343ac059"
    sha256 cellar: :any,                 arm64_linux:   "51d719d5a7dd034f6dd61c2126b13246d7dde2342c945a30527c77fc836660e7"
    sha256 cellar: :any,                 x86_64_linux:  "076cfc1932997e56f22b9d31925535524ee315632397070e1d709b58bdef839c"
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
