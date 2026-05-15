class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.23.0.tar.gz"
  sha256 "82142bd2a29f2414a8da057371469526a7c7ffac0ee8c2451dbe22ef5aa7921b"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fc4200a28a83c5511b1c8e61f97f0ad391d196a1a08f94ed232e469d185c3fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88eef96538ae9fda82825b1a5a5c599b8f0a41886f7ce941c3d751b7e465f554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc04bf639bfaa0383f97d6d2c2bd0743f54fac5b8632682f39eb05a52237a439"
    sha256 cellar: :any_skip_relocation, sonoma:        "b454d9f376b7510778c8acaad7f9c7dceb34a7d654c48ee5b1a1883d15148af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e9c6efa86129bb9b771947cfe7c5a4d4f8e42ac34843765ac9779704277f75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdfec57a16428f71039d8c3d74c68a220c93af425de6d4ac6603a87aab85946f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "exports/completion.bash" => "pdu"
    fish_completion.install "exports/completion.fish" => "pdu.fish"
    zsh_completion.install "exports/completion.zsh" => "_pdu"
    man1.install "exports/pdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
