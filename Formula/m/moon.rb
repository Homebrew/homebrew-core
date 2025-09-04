class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "f8562d286e6c0c1ccf9ac4c5307398aa9bffaf55375bf74f372c2e576c341b2e"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02382f6d88eeddc09046fdcdc1bc2a942e07ba04e1798f717302ed31fe331b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72388c204c02117c52663e037ca9ef57508d686db11bfc40547f633a17f3ea01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7108fe13c7ca3d4fb9356accd5119704938a138c30c3030ca3d78101fe15140b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6eaf65708dadfc187c5b12064035b37910136531c16e1b75d4930b643abfe892"
    sha256 cellar: :any_skip_relocation, ventura:       "7ea88b5351c9a50cdd584795415cd5c3832deff77da9ec9e2921b6036ac6c9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881f65930713bf09a543474c590301cb088c301b9058c541900c87d508e7523c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcf47dc5bac4d19085fa1ac5d0b26a12331595edd2cb83ca2c4baa97c62a638"
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
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/id"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
