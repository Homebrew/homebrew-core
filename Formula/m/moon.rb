class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "f4fb76d83004ddc7274f635009c40ea518b2bba8dc62dbd16d89fa70728ec525"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bbc753d0d7bd855650284e03f18a4537cbe3bbd411714333e77952739b1526b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4661a550a28d52bd68d334063b6122d1c0a62c0fe03b6335d3cbaf8da7ee5b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2099e44745e87529f056992c5ff9d0ec59721acb9777583cdbe1b8941ce003e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f13c82bc2c06d5cb9f6df9ab4b147320e68efc376ee061cb6eac342636ce7a"
    sha256 cellar: :any_skip_relocation, ventura:       "0523eb8acd78c4e1e31d64ed67e24bbab13798c1e72b06c54e6ce85111c6a1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056b9ca81104861dee9d9f9d48bd3f297b0fcf7df2a46b1a83a00f049dcac8cd"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
