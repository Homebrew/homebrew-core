class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "db230be91fa6b7bfd34c9b6a4f438fd62862c1c18e8bf089798694ea7badfa82"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b1d1cfaa07ed07e96c40d7a1c800a7a9d22862e418e44cfce7c316db23b5c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f6613ed3402e256c01132ba2fb6729942fc0732c6e0b20a8ddad08c8e03e410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b66cf9c4c2a01c463289e1e73acfbf3c641a46e3d9fd8146049d42039d269f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2cd1d9825b0d884a3d0e691f0e8bebc345bd2193042a73e0daf1c3ce440b213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96efab7d129313ac8cf43788d5e55e066fb5c93a2ef691a24e70e899126462c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "511551488286dc45b01d80cdb0a7639eb9a1b04ce7e908a5a3422d779adaa897"
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
