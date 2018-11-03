class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.19.1.tar.gz"
  sha256 "050e1f06a2537a7be4987a9fee103dea60bf1dfef06f3ef96bbea754609d4843"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f1cd9309524378a11a8e5df33b8abf6389b2033084588da021be4e3c8b3c8bb" => :mojave
    sha256 "b4c4dc6e03087fd9afb848f98cc3ff42b441e58deebf9999f57775817345453c" => :high_sierra
    sha256 "24244ce4fd50726f72dacd18e83d3e6734b07ad5dabdc49a9ca1ce2f116dff50" => :sierra
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/leancloud/"
    ln_s buildpath, buildpath/"src/github.com/leancloud/lean-cli"
    system "go", "build", "-o", bin/"lean",
                 "-ldflags", "-X main.pkgType=#{build_from}",
                 "github.com/leancloud/lean-cli/lean"
    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
  end
end
