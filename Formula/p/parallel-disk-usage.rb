class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.22.0.tar.gz"
  sha256 "56a559fe591539b6a843ed6b4f2cf02a0eb759f5fbe905d2784f83beecda913d"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96e1af400bf5ee16bc817f7255bccf6fef48c969a0b03dd08c55355c54ae6c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707a8f9583cf1fe2f56580483274f38eaeea6ffaa4e6bf44ac192b68b1ee4a54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af0e37f6caf00e453d4d5cbce806445c34d87538c807c2683395d82213a2821e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc179d070637fa07b93da82b7cf9de78ac1ad60f635f0d72c7571b2b2d2ef9c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33f3c0463798613bbc228fb439993641d050c9ef3d80ae7f5abed9d588a7609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f8f233b0fbc50aa4e8bdd33aac0bc2fdbe3ae4284a3cf1f5c019ef1513ec66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: ["cli"])

    bash_completion.install "exports/completion.bash" => "pdu"
    fish_completion.install "exports/completion.fish" => "pdu.fish"
    zsh_completion.install "exports/completion.zsh" => "_pdu"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
