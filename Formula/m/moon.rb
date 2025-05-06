class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.35.5.tar.gz"
  sha256 "5899830c67ffe8beb6114f1ac1e74d989cf4fe110450a75e53d03f392ed3f6e6"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91e24e013a70189dd5ebe4e79d49e8358ae44e1f1d3f90f4774dad57266dcf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84bfbe8767d8ba62df9d6883fa34bbe2866ff6ffd5615c29a6a00ddad5686a39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e904045f6d1edf6083fc3812b1d1401410329d0f6f609281be3cb6cd6aba77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f75adc4868847b67493665037c35d20e2319c3d0344cfc069113e9b5e3c2faba"
    sha256 cellar: :any_skip_relocation, ventura:       "701424e823e496c290454bf1d2d6babafccbba13876a877899f61d22b1c17774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19b8bc71fb7d9defe26fe8510b79b0c10ba2e88cc85e1de82439f8a3a478e41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5728b3e8176cd61753856490b0b87e823086f528ede830f479d6dd430980c06"
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
