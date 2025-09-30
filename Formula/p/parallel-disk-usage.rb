class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.21.1.tar.gz"
  sha256 "738344d89d0e7208ae501f1a96babfa5bfddac13a925c0a6a7332d759a3e643b"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087a9b44fb17f904a0e64a630d18731f378938a06c1d4e1db97c313ba2df0208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff8961cca5f1555d8e00546b937331b5195d1cdddd15146067534f444a630e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f6a3b9fb2cd8271f2bb0d62b08a0f997172591b2776147d6af15ee1bea2086"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34c0d90115cfb290f25cdecc1daab6cb57295d54891383ab404cac4fc61a9ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fa92ee454fc377cdd4e9b62c575a7662476f65c7cb931ef228b3881510e4950"
    sha256 cellar: :any_skip_relocation, ventura:       "9171d44725889e7c12744474a8a751fca879ca1f110ab00482007f6e983694e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678ffd25de3bec4c4ecc1a0b6cbed1abaf106f45e4c51f0bdb1f5a13ba01c7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7813849ca8a1207d5cea8be2fa5d8ec038ccab966a81efc39ec19c4a24cebdd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli,cli-completions", *std_cargo_args

    system bin/"pdu-completions", "--name", "pdu", "--shell", "bash", "--output", "pdu.bash"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "fish", "--output", "pdu.fish"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "zsh", "--output", "_pdu"
    bash_completion.install "pdu.bash" => "pdu"
    fish_completion.install "pdu.fish"
    zsh_completion.install "_pdu"

    rm bin/"pdu-completions"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
