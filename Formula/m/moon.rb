class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "bfab2205f40d51eef6d87d7b1d40956c78463eb6f38a697817ec94312ede85c4"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caae1802bc7868de0edc3fe461e1048fbf45b247efe56831412264ccb92df165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f9777be02d58971a6dda31b427c4ee953aa8feef7546de6308bbb3b2409b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db2cc35bd09c1cab371edd66fe76c7b6220ba10f012f3aea97e2d005fa0159af"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5fcedcc331707cc918f249cd77786caa733717d04887e26052a3f13b1c9e2a"
    sha256 cellar: :any,                 arm64_linux:   "950e21ad147000d02c9ea768b360ca4d8af6938c78e14d02d23ec15d4b198d55"
    sha256 cellar: :any,                 x86_64_linux:  "9813e696262da4c8013cc6b1991a8f9d3bcd11b0aefe5dfde5c48c9a2abfbb34"
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
