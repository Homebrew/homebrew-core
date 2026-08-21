class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "3db63c8244978e580deeffbd29f8077455dbafc8f80ca8df4351a612881000b8"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de0880426fa36d5edf90f28ba81e36204438190261fa5430ff1bb92ca7a79f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b2d207b33c3a685ad4e3ba3f85c3f1341084fda3f3b393eba71e5a9765ab5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b546f4b526efb051af87ae996fd8cc8f62ea037a9adb0a48cac6f0e69b59dd11"
    sha256 cellar: :any_skip_relocation, sonoma:        "5344d61fe3725768f300e1e073ec32c85e4bea82abb7969d82fd0faccf2a4326"
    sha256 cellar: :any,                 arm64_linux:   "5201f06acd17285d8217586f5c8d7f1f38f31718d3a280cc16d8a247e6c533d1"
    sha256 cellar: :any,                 x86_64_linux:  "80e878ea62a1cddbe4b4bb80404ff06be4f6c03cfd28a59caaabd16579fc9a7c"
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
