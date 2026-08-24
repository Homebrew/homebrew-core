class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "5cfb2789ea16c3feca01e9706055a098ac1ccdf841e22b65405a46c182b89408"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "159b3ccbef7382708449affaafc77485cae813c7f2ffdcffbadc801910411f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94975229ec0be47a83240d6038d8761866320566329c84b4dff706b5a37772a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a049ea474c3e1607cd4ab91f9a16caca02c06ee96aa27a10a708730d88bf42"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32c4bfdb79e7859b522257dc0de2ed894dc9a0ff438d691c5c158395e93afa2"
    sha256 cellar: :any,                 arm64_linux:   "e8ff970d3470e8936efcda7f7336226ce43ddf997f95fffbaa08be949b028cf2"
    sha256 cellar: :any,                 x86_64_linux:  "d2e3f9e666ef5f01b6ba09fee0e740fe3d7213814a3f6c0ad4c5a635280720cc"
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
