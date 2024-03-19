class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "fa1b0846f4982ea029d0f1ee810991e966abdf10ea67b50abb7070604f0cb075"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26630c7a86c60b8a1eada9545c66c6d649c49f80702505afb9616e60741b31ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2bf6a82fdd5b4f544bdf4a1dca9533f79934ee7a40dacc7601832a43542279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a6d2ddc17a31572570929b60920e652471f2a53d8822a005eaca8fd1fe9e60"
    sha256 cellar: :any_skip_relocation, sonoma:         "45d4b361966f77aa7e909f079450f0b34c3ad4b116b0039a9ba2ea82774569d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1b74a3aaeb165defafeb53fa470d7830e0523b147e48261efcd88cb1811cf0a5"
    sha256 cellar: :any_skip_relocation, monterey:       "f8debea36cf5b9e457d2b002c5e50a1c895bbd520e9323353fc39829963532b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ddf5a3b2316a04cf1b77ce58e6fb4b162d5f81621c810a2f1936a622498ea1"
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
