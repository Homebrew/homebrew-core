class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "21e0bbc2be7a84f59450a93ecb490bafbfca1818feab06c47ecc7913c989c00d"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "234be0b1a504743178d94f296f9abe49068a04d379bb85076a3a41ca0a5956f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8be4316530017c6186a298a5d3d80a216abc754ab8590ad9f66bb21112eac068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dafdb173f814c9a4c6d74f7aef5389021f6d14af6e2a37721d1a76218df02f1"
    sha256 cellar: :any,                 arm64_linux:       "cdf37ed373b38e12fab323500967fd5d72daf170d1374ca8963a7560802712e5"
    sha256 cellar: :any,                 x86_64_linux:      "6bf90e80dd9b30d702f2aa4d837ba33c1819afb82a2ebedbb4a483437aeb7622"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
