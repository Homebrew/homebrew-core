class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "57b22f55c5683c8ddb0b6bb051c4f64660a4bc607ac78b8c01b9d75f6b56295e"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26d4791e740cfb9c2e336cdde9f101f73eeac09b390420a5c0de03ee89b31553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfa26c8bfec7ab3ce0bbc3e7af98f4dda0d5e67a51b36675ae909381c5a5739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a766d05acb00b43b6c5ad5e4cab41b6169837285bbeef0f383c0cdced945add6"
    sha256 cellar: :any_skip_relocation, sonoma:        "26dfa968300ef29346ab0c7249bad175eeb26093143f87f62a9754aa6d3b049d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd9e4c4acaeb513c089efcca8262b8efa7aefffe33db2aa46c9d2472287794d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f7d9c94409f5d5c9ab845831776168cf35f6f13514359cbb879e7414af20df0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
