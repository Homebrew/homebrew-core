class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.10.0",
      revision: "ec14d34d399c803a194e7c579567750f0f712456"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d29e05ad911328d48272b4b69c4b9ff56c062a6cd3c718162a74885ed6738f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83008294392f39560b588a6dd4c9c26fead24044203148e34de07fd35693a421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf97c3676a42a651e2942c3c350b661f60d8d75e0d75db02734b9ffbc1de6fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c082dffec94264539c1a8f682b69dfb447dba0b27676abd659af21f011c88aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a5c7a680e478eadd1ddf981b1ba9a01d19e697bb63c8c17300a837016d6b85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a04d2d91f6b02113d6fc667bbdcd0fe6440c3042fb78f53ce0f8a80b2bb6de0"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    fish_completion.install "misc/fish/ghq.fish"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
