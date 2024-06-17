class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.25.6.tar.gz"
  sha256 "e67b03f46e020a8a422f48dbaecbcf0b95bd0a0894e899aff71593b83999e8e0"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "978014756d5406b76fbf9068e0a77c63ff0e5f80538c13bb5431466c963330db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "981bff9523b4b9d497f207b4174a62065360f90207cb4288e12dfb73ada53938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b9d71db53ce4803bff2a7ecf8cccc7c05e717937f7bab96cc1bdb0e2631e737"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a8c080ff67a79be3c483cd8aedeb8931d3fe6cab71e3680720b2d01328dff22"
    sha256 cellar: :any_skip_relocation, ventura:        "27402f9e8a846726daf77ecebe9661ea35df9255dc79f2ccfc269ea966d39345"
    sha256 cellar: :any_skip_relocation, monterey:       "154850922da6494f505263cdadd63c632614463d4fb5c166f741a6e9bbc30c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea31c63f5f0850b9fa317666e0d2660a4b7de0d154dd3d4f09d7311567637b53"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacy/cli")
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
