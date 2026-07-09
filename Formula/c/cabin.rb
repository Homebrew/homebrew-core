class Cabin < Formula
  desc "Package manager and build system for C/C++"
  homepage "https://cabinpkg.com"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.17.0.tar.gz"
  sha256 "226a228cadc3f5451492751db766d8e999de5f73c9e2a90226037741056b594c"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f369754eb1361b9acdc63fe4da8573c6d833715a6ec22651641e85fbe59bc7c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4624352ed3494fe3868cf2c1d2925917076935246f12c808d159f14bd04542fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efaf178a08487d67ed0c3704c60ea76cc5c30f01cd8a1399e8fde0d8f501b773"
    sha256 cellar: :any_skip_relocation, sonoma:        "e26a8bf88ed3fa88d0a72393e4e163a96dda7216e461a6aecfacac567d401027"
    sha256 cellar: :any,                 arm64_linux:   "6cf9cb6ace64814766b7cccc78220cfd23a179212450695b9b87a948bc0ba49d"
    sha256 cellar: :any,                 x86_64_linux:  "45aac837e76eff62864ce15f44478065275ed080130298a8d200c8342b59138d"
  end

  depends_on "rust" => :build
  depends_on "ninja" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cabin")
    generate_completions_from_executable bin/"cabin", "compgen"
    system bin/"cabin", "mangen", "--output-dir", man1
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello from Cabin", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
