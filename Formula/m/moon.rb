class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "56fdbc30418567f5c6111559eb110e1ae6646b435478897eabd56e4996a7086f"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc1f2c848340b2edf17cdd8d16643e204d5fa89ec8630faeff103ff7ede9edd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b17f8d635c7e5094a7ffccae035720a53c51012e13918c57c8c0606c2147f3dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "942914e991ada2e7bfdceb28a2cd02e51a9741110cfa8dfc24c1abc5c5da8c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d71a7939491554636cc483bd5b037d268f86817c552d42e6b7094d1b4990058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bfe0589b00a09e812822feb18b1a3649b71376253a26dbfb0e148f642435341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "321d92bfd8bae5bf2cfe169ca471e7ee2411979799348b02b7b7ebe8d9d9375c"
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
