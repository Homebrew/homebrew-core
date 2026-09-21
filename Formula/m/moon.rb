class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "7d9fa3040bfa76a54d8d23e73427bd055cc54751a0dfb789179c1e68c0a1612b"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b68aa70af4710fc5b238ae155010887f8b36a912ff3e04c2920fd35270a18202"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dafe9f35d304fdc581ad10e9e48744dc357594d245fdf8fdb5320f710169483f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a9c4f85cca16d496e3c56f35c1fabe18d3ca197ae7055ab2b3fd7cfbc06a6ff"
    sha256 cellar: :any,                 arm64_linux:       "b32393e3d4d1c2c991ef4f13495ded0581b470fb5894e8ced23c95946719be61"
    sha256 cellar: :any,                 x86_64_linux:      "068805cc4844af1e0d66eb035185ef011ffc2336642a4b258134dd898530eda6"
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
