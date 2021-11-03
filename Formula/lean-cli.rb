class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.28.2.tar.gz"
  sha256 "ab6ab44e02ce17767065a865f72c48fc8c9cd8fbe0969c729b96db0bc25854a7"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c229d8432db9da79add2a8f6b08d2ee42e811464839e6cc94ec188aca7fbca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15eedea83df35c7eaf620a3f9cb5fa4bdff1aa1ac30beee042127d676a2ca868"
    sha256 cellar: :any_skip_relocation, monterey:       "1690414d4ca4c2da7879a6fb387add0b6c74061720fbcddb37281c465c6256aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9973146a4bf2be81ea5a00dae98601e1e7eed9d9434461bb9cfb703e7015017"
    sha256 cellar: :any_skip_relocation, catalina:       "78351076fcbe6d9071b6a29f03df6e5eb61497660c426c1aa2f7a892552d7964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721c92ba95726b42020332544d66e1df3312de0e17658d9914eade35fdae921e"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
