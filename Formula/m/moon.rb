class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "eba7b5d2d66c872e06e746acff9e7eb30081ce1876dba3f0280d36cc5fad654e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4d2ca4be50b2f8e574a8cee7b99a52dcadbdf139a11a1dd26520622bb84fb58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e783011d52483ecabe4e82c749e80ec82abd90c549d57b3879cec96e17ffc9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a31f07a34503fb31c2ada92530678778b36eb454291d2656f4baf00a46625468"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c1ba9cf9c52c52b95e87ae9b3cdd6f23cd2cf1c1eca9170f0443521b8f94da0"
    sha256 cellar: :any_skip_relocation, ventura:        "8e786388d57722190d7af6108d680f4f287e8d255e0c4d58aa78d2738654e230"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc8690010810e8af06f6d8d29342bd5ec042f678f13cafb9f297a8684b879d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829f92fc0eb450cc5b1d385c8298862719f7cd8d41b416d5de907c3acb91c498"
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
