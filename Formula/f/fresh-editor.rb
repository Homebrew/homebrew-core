class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3504d47cd0ae3d37e397d46088ff2c7096405498ed4079b2df16e399a1b36608"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f24e58554bfe2b7f85227d060a284787e65cab08646b8ebe61a2aeaa9741d04f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89d79cefa92b21a37afb0c9f0e17851e67b0bc1068a9bd4dd9d64675d7b3a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db16e12cab9e1ae0b1a08ad8fe6d18b83baf208bf1cb0066bd1d0072fd5424f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2150eb7113742ad20e60cfd1e40186c025cf1284fd18f5a546604bd495dd0ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "492170331fda19eb46dc6bbd2ab1ccb028aa6f8c42ece14fea589feba55b66ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455fced21203ad2bce00a504852632a93ad790d1617ec6c3bcf0bf507e8efe29"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
