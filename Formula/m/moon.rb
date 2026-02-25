class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "9de582fc0fbf5a6ec25c29ec6b3e1b9f78395bf04fbfbceddc48eb0c04a80c21"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3faa37537791d7a5906ae89e250e6817f61f487332400b5bca549065de75201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06144f5ceece48955f0635da8e36cc4d43742d295c19f864d28a0e16b601f53a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "942463aac13c58288d0539acf6b5e9063699364ba7052c0383f92d056850f27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d3be206f8a6abdfc413e1f24d47e1d6041318b72d4624da4d0b8cefb0181c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2654c95a5902c07157eb33d66ab4a13027ea3b32949df7670cd9f579ef050342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfde991e332d0f1d26974505a8168c1185e784c7d2c87cc0a17608a8978add2"
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
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
