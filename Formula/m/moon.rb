class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "53e7cf67f631ddc0978133cee29806fb53cc4cde9f3ffdbba0524597691cdda6"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ec4f2517eada6b0d54f8f54533f3ccff5d5086f4480e5dd70ac9c24e7d6300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7f6e8446e4c01ae13fb9d9e21527c35e4162e929c8f803c8279b8fdf30bdb98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1e015453dbea05578c91d9cd7a098ed6670b9fd07ec4659bf3538bb805f0c65"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ca4223acb5ab507e83ea9dbd53864dcad914b7968af9e62ee338b88e39aa0a"
    sha256 cellar: :any_skip_relocation, ventura:       "654f0f2f9e8b6d76b62ac1764539777bc762a7f2b58e9c7621daeaf80c160afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54a634e5158ba77d882d2216dc7576d314a986d5366db3f1aaec3a6bcdd39a7f"
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
