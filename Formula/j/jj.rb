class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "bac30443ca362b3854f1478866f86e2f640ae4993d7581867c129ff9006f0759"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14f49fa000f4cabaf68ff81c6ce7e5b175950fbc74494918fa7998613ada8d81"
    sha256 cellar: :any,                 arm64_ventura:  "e00b7fb1077b5d77e63a308dc0b3fb8eecf62a9fa74a5d34f42ac6b5a4537b11"
    sha256 cellar: :any,                 arm64_monterey: "bc02e5edde88b774262280469490a68a8ef0c7d6cee43428b42513a1ed547e6b"
    sha256 cellar: :any,                 sonoma:         "09613140bcbd047804d60dce04505ab48192a10d39cfff01ce2a905ebca7fbb6"
    sha256 cellar: :any,                 ventura:        "b30359fa0f249755488d391d51b1f12c769585b1e6a6e0abd3add8a3f1c75099"
    sha256 cellar: :any,                 monterey:       "cd3f5caa459f22e841507f8c814384f75f84a82417a3958534478f066c9bd160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76f42431be36c15dce1b3655ffe76a2d51afca909f7013d2c3f277c24151967"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
