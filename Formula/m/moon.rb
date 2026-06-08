class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "ad93ca6c53b5fbb7f937be0d177ccc932d51064df940d75167600d9694e26004"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5447a9afeadb0337eef09f9559b618d69e63b1e166b7ce6c52b33a46809ab03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78bcfbffde5a736b66ec0eeb7e6472458a06d4d06a8342a49cd8941660da1e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851e88e3f0434e37af04a5944ad70dbceefbcd97a577afca3bc398aa9627c53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d134811bdb3f9182450a994f8b00777644ab2331a479b4ae2341e94fd4c7412"
    sha256 cellar: :any,                 arm64_linux:   "cc084e83d993aaa1e19aa81c687fcb1e1c0aa1dec50bf0f6968cfa95179cad7d"
    sha256 cellar: :any,                 x86_64_linux:  "7a30320eb3fdee194f03396a900d44875d55807e358e2fb5f64bccd464c9aa62"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
