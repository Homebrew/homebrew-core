class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.4.0.tar.gz"
  sha256 "0cce607454972c18bc4a30d2f44a2c91fccf02c458475fda7720370a3dc8a4f0"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "098b4048f51d50dd079fff3c456e64160880e581f4146068bd60abd6ab0718cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f18b49331a18ccd1faba7b6ac13a06bea6f849ab64083ee3d67c9e5fbe987fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03bf4057800160009e2c424e4521357f8659b6fb7fa4ee23210d65e378b4a91f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d53619148465d9c35e4d2bc7bbc8db0fad6040002f17ace31aba77dc1157325a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607f7b829ea9cefee2bd2181bcfe897d408f8d2acb0659e8cdfe6279c4487d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5616dd6646beeafaff8e3d100efa6ca92f51ffc8af360a96f1121040cc939f25"
  end

  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end
