class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "b47ca060c92af747a34b57d0e87aacd1256778d3bfe3144728f6aebc56eb9ee2"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b09cd132f2c1f3f9c79c693b425ae9f00c7b97bba56b3feea9182c1a26627639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de6c805238fb512475e49c49399e194a5f72befe0c8735ad48643674df892a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a4102557b255876ef2fc1468aba6d4b21fffbc4dcf5c8a6e071d7f7d5cdf995"
    sha256 cellar: :any,                 arm64_linux:   "f6bd5b58e5dff4d5aeb02dd344489196887881715b40425de123c39cc9195803"
    sha256 cellar: :any,                 x86_64_linux:  "26ce3341a05ac09dc8a79a94541820939b1b6ebf7d371e4169cca4e89d732946"
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
