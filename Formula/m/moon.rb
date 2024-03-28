class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "3c18d1c6e617ce554c72687edda90dc8fe3bc90089e68b28c4c0beef2247cf22"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1781af9d0d127d7e4068e9189c0ca981cf8bba0c63cda2097fde63b184297d3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ac50710b6a90c60a7786c0797708c1d0a498abb8dfdc5eb6996570bdd14b667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c784a491a3d7882dcbbb98f7dd09b32410152cf34a642280e7a3a620484660e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bf391a05d5227f4c2aa2747f432423396835e3bf606f84d2b251a1e55d44597"
    sha256 cellar: :any_skip_relocation, ventura:        "96e3391816f4f6e20d61b92f3fd0af7219fe1fc7e40cf1fd15c84c55216a4070"
    sha256 cellar: :any_skip_relocation, monterey:       "585755f34d7116a03b86241929734b1680deee6ae651ae0d5e90315d079b6f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a93373d53176cbf476cfe0c87bf8fff068044c3ef6896f324e9819570a62172"
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
