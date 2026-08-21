class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.24.0.tar.gz"
  sha256 "3250ede56826cc268c8fb05db8ce345204ec79ce541cd339ffdad9747c2b853c"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c5aee987829fdf2db5af5523b867e3615f0d2b2af05f601d6094e0e086bdb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592ef84757c9f751ec35c9f01cdacecac8c38f7cd73e338e6bfed6b67571a166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bcaab70eb577ef2777b7577da0e37a4f398ce9999ebc799470d1baef200c90"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba4bbbec6968e1a1084499788b2447e22e37d9b270411ce958ee64047005c332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8706e88c9782c3b8dfd71ffdedc70202ea7c207f68cd7ef5a773381c5f5080a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3352f5bcc54da830d134d15751c908cfb49b8d5d70f04546d603bc3e9bd25edd"
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
