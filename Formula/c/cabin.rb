class Cabin < Formula
  desc "Package manager and build system for C/C++"
  homepage "https://cabinpkg.com"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.16.0.tar.gz"
  sha256 "c6590ea64f228cecd47606518f50bbeb8e96a28a8aa55b4b3f7dd699b57b51fe"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bce5ace9937055bef0a6fc3dfde2f2e8bdfc3229fa70cca2fc9da1a2385fa17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfb7dae5bda853c27dbc0ddee7cafafd952f1960aedf718330e1e132edd399d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50c17ca6d62b85bb6421e5d85bf9f07eddff33b88353aeb21f667dffe386eae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec14c54d3e7f14e96ef45ce5f9c75c59e06bb1f9e7c673aa44a4d50ef6358b9"
    sha256 cellar: :any,                 arm64_linux:   "23e0bc964c7b5cdebf0033ee6103e3c38f3651941649b371219e35b44de60958"
    sha256 cellar: :any,                 x86_64_linux:  "0fe7882f999af9e465bc3231fff9f57c62395b3ce0b989b22e70a6d1ffce1bf2"
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
