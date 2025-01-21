class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.11.0.tar.gz"
  sha256 "a11e19906981c46d5cc694cfc2908163e88d84cd9f4f8b2d516487e5f150d588"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a80c6cab3c8a5865b1b518f193f63d49dd6d7990d45d725407faa3afb55927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b5f5b49a939dd902b34b6d13be2aa49d632ca8fce5b5754ba397d358699ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813b20404ed758b4e2fceecc75ef706871696c98930ad185f182fd14c96bc20b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab569a47c73fcfa96edf0bcb3015caee836d7630ed0b064533c9e258382fc0ec"
    sha256 cellar: :any_skip_relocation, ventura:       "27d6b6a2502e8c45bb315b12864ce6fe7a8d9c07ef2bccffc7dd1f4547fc72a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f233a9ade03a7211653eca2b211b91538a9c54a5f4ebfab3b0865c9b4eb168d4"
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
