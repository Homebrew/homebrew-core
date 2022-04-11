class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v2.0.0.tar.gz"
  sha256 "e874549e1447ee849543828f49c4c1657f7e6cfe787deea13d44241666d4aaa0"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "055f23fe08b6fcc571118f2d1c7b287e54df49ecd9ef9967adae398d7e7d4a51"
    sha256 cellar: :any,                 arm64_big_sur:  "5c402baebf764d85e7c045d2f3b4e89ed87cc72ae07ebac225307ea868cd316a"
    sha256 cellar: :any,                 monterey:       "b0e06fa85b6abf97fe50673a6a7ad32c11e6b804127176d82bcbaf4f53cdaf9f"
    sha256 cellar: :any,                 big_sur:        "affcb7b51d750d66987a5c1d1a46099327f33770711e9e720d0d6bc77746bace"
    sha256 cellar: :any,                 catalina:       "9222213a6c7510c26fd4768070764b5bbe4150333066153f1972630578c247ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dffec2bb02fd80e9d907e87b7080b67c19c98a24878dab67595e88beff5817b"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [OPTIONS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "ERROR eureka > No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end
