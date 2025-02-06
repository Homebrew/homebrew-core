class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.8.0.tar.gz"
  sha256 "3ce5648614b10369e6b158596b17bad0c2411d02ea317dca4dd06b26712fe279"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9ba3433133bf1eba224a344f93a1371991b65f7ed35f0c545d4a0c810147c9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a03e20f6ca7dd8061fd07934210b3beb48b1a274ee01511de6f67285d0e5f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e77721479af5c870b33acd47db8a05d8fbab0e04d96d66a342ee27279cd23c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9284ddac1a591ca03badcb8f1021371c798d6536adb2e2d908cbd9be01a96c8"
    sha256 cellar: :any_skip_relocation, ventura:       "903504fb4c6ea77c585235ae25cfa863abbd7367d805807679fa08d9c2cefab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392af8b64d2a147d8fda3f7960a6ca27573177a4883f8eb05caf15941bad15f5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_predicate testpath/"helloworld.tar.gz", :exist?
  end
end
