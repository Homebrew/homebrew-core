class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "73e4e10c5dcf43bd81d42a83383381d97dcf670c0bea43b9416d01d38d882f56"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83fa173d73d17b242bc399e7086d4f2ebff552260aa848ea0a4be9fff646db7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6f9f4cdfc077f396a62b909794f6c10b5eb9ba10de1070e9e4369e587645c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bab9bfb7fd1a139dd48d247e395606887dd2f416cbee9e3fe03ded72289abb69"
    sha256 cellar: :any_skip_relocation, sonoma:        "9baa235cea5dc56311eb013505af0afd6b24d060eef4a6a551e951b89763558e"
    sha256 cellar: :any_skip_relocation, ventura:       "f68871f3f5094736b91ea6b62c9771da05b57c4be6f2792c3d2066add2900e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fea068620a47dedaf81c15dce9710bc3e3a3f6218313d40a64df3b87df5e276"
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
