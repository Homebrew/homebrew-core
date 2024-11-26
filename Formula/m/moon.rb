class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "bf1cfe31092c2eb335be8ce825ee345a49870039b20b27d1aadcb22761fcd0b4"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc5332cf0cd6f3cc8938618e18859ac412e136a4bdc08da08eb6eadf03bfe58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57fa0f7f7d725e7671b36a48da19297b401f31c55128209a72a0fa34e8b825cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9be8b7d95e4475427f3013b3d48ae27921dd47709caf26ae6231976940c0aaf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e97c1520699c512964985544c6533b51570330b5c039e50afd4e9c9538adc65b"
    sha256 cellar: :any_skip_relocation, ventura:       "35cdb728f3bc416b4ed1c8e2c5ec726976c6578be344acbf365ff82f5e9a0095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6904b17b189b0f604f4d773e044c9a53142d928c3c0723bd64bea2bf44b7b0"
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
