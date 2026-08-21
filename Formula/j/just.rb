class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://github.com/casey/just/archive/refs/tags/1.58.0.tar.gz"
  sha256 "c8a36e6e9397f2fdfcb0cc246fcdb790b52a784f3c8cabc0d8baeb031852a148"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94c7ff64ead65f2ea22f4e079245eb70410ce3590f64171007054bda67fe4859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a886c886c197aa176592772dcedc04d06a3fdf16f5c86548500c81a40b6237d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d408b67f8fa9322f6c77146a42f240f1e900026a4b94f70e6ec1e02fa348ac8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "244656367fd16d19e250b024dd8a8a81cac3e8a94282920a5d03c3b929bef427"
    sha256 cellar: :any,                 arm64_linux:   "e49407171fd003c94ede235912ace0c9fd21588e0ba6dc59f30ce3cc2a549155"
    sha256 cellar: :any,                 x86_64_linux:  "2eb3b0b7b2926ba5e384d15917eb1828eb16b2f705ade2edd04a95ceeb351e05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
