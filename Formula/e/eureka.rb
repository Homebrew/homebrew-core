class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e874549e1447ee849543828f49c4c1657f7e6cfe787deea13d44241666d4aaa0"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a6de6aac51a1f6070476d08477d227d50b78ffd6b4c6a0d5e2d49b4676ca8db8"
    sha256 cellar: :any,                 arm64_sequoia: "cccdf775ed4f873ba36ce03a0f044c8332e72820aa2eac3415c863bff9f3bc3a"
    sha256 cellar: :any,                 arm64_sonoma:  "23e91b5afc7970d9df55240b2253fccda506da2c433b35ced751b1d7af89743f"
    sha256 cellar: :any,                 sonoma:        "3a266fce693e780d3544d243a2a3216f9af32954c983555bc92dfbb6ceb02876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40bc0dc3cca65bc7d4edfb6f40dfa33e5cdc742d462e63998b814e26d7959e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb5f7b3f67f69af0ee2a55e048b067d644a980fa8bac2915f413c96b2cb6d64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [OPTIONS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "ERROR eureka > No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end
