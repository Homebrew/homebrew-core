class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "877d841b2e26d26d0f0f2e6f1dab3ea2fdda38c345abcd25085a3f659c24e013"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f54db87868d342a1beec363a8baed41aa8811bb174c5080b4577a3c5adaa616e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a327a9734f25a095dce2dbb1ce1eadfb92f8ee3c6c7142206020f4484e2cfb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fcb2aad5679f0b24189b902b91f1b494f404e889739a9cd03c5e0f73a4a8066"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6bfdf961c35b520c978819cdb94dd122fb304a44336179289a944467bb9f1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "793646259d3c902d1671f9a23846eb474429958d58a72bb2eb72f179c8a4058c"
    sha256 cellar: :any_skip_relocation, monterey:       "558f4ae6a1d684b76f5a3004b7a0a84416f4b5fa6175fd79e8cfe5d5c8f6b5a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a52ad2c5bd3960335aaa286a261c5676aa431e2b4d5dff184f93f0999a9686b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgetc.install Dir["config/*.toml"]
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    fork { exec bin/"joshuto", "--path", testpath }

    assert_match "joshuto-#{version}", shell_output(bin/"joshuto --version")
  end
end
