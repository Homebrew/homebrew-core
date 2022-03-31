class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.28.0",
      revision: "32f2b505c52331b494018fabcd0468687d0d8199"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01fc92f8701075c13283b9dc7a33db1a6e89dc08fd08231e0f5591834ff47a6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49d912363b46ebc9189571a10b5fde2731b7ed0f104c22a076862aa43023f4b4"
    sha256 cellar: :any_skip_relocation, monterey:       "6e957ea80666793037f3a56530a19019d29ff7b544646aebf8f278737e4686ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b56894bb232118b26c171f44b78b4a1f851c5c92b26c8427b5a6edb29933ee"
    sha256 cellar: :any_skip_relocation, catalina:       "027a0cdbca726ce8758ab760a6b8aa6bede5afa49c41646fb5243e7f70410c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7638cabca4b5373a0f78739486dd760e17b0aeb644724823c26dcd55ba6d8f9c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
