class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "c76566378d8aca166ba33e441d9730e01838ade28f221e9256d5123c1d75e560"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fe791ee275e50ffa8eb284b16b67c09f9e5e16f7929ffe2dd1f7abd8457b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbcd3d9f05f0eae7b66de8a63d9c3c90ed6bfe75ac91cd65495a750dc6d72db9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa988e84b92ac30c144e054e44dfac65e0a7837c52a24e684bf8c3b38ffc6fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "74e9868f508684615655dc5863a4f9119f34df4c04c4dd9ddbae26f86eba140f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c2380882d2fbcc5c1695d1a24d523403bc6e4ec6bfec0bf07d13b6b9ddeff28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb9074c42262214c706cf4810971c2890a8d75b133781519a111c3887c55601b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    bash_completion.install "completions/bash/g-completion.bash" => "g"
    fish_completion.install "completions/fish/g.fish"
    zsh_completion.install "completions/zsh/_g"
    man1.install buildpath.glob("man/*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
