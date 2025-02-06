class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "cc087bb8a345d1339cf14e74540ed626718dd203af1376217186157810483b2d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50b7794429039a7dede650581722cdda7fce205a30f9f84a5d10d73081cbba0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8816a3a48bce65046c9cc780e29b83c0c83bd1808e047ee88e23d0bb5902042"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51a3617b006121e2732193a8c8f48d67ab9c557d90c1f024e35990adac750381"
    sha256 cellar: :any_skip_relocation, sonoma:        "91275b800169b9841f42f58781085a852ac30f4b86ba6b0eea30a7eafcd0d5bc"
    sha256 cellar: :any_skip_relocation, ventura:       "423bfac4cbab1132ae9d3e724e3297c8dbfc7b9e810f016af205e9486f2bb5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e78c3aa7eabd5a5974f615e4439b33e92a3d2933971ff0df434af400b8b0d454"
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
