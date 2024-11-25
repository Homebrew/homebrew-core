class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "4d34851b666805ee368edbe9aa679605122f63bd1bc7bab5d4de52463b8aa6c7"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f54f43f234aafe238b3fd58dbb71f6562e5775214b10d6d67954bbea1673bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83219e8ea564e4871dd1824e454612e911982f2ad86ad9ac33f16e9dad08fab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8929cd336235661dccf2cca43d7925df261a0e21f8c6f57c53d58b274d0877a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c6b7e484e83bbac3a60208ead76ce6fa16216e6e5720653ddee66619f392a2"
    sha256 cellar: :any_skip_relocation, ventura:       "cdcfe069cf63edc5fba6c3c7dbca9d4b2984c6b30d74092303ac98dea8204baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fef0cfb489bc789fe14e585fe36af1123c4c4cc16d7aec333feeae81f12f16a"
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
