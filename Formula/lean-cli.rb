class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.18.3.tar.gz"
  sha256 "ef8212965d303bd053cb56ff0f4a751e3c184a690e4187a569ba7f990bbe5986"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df30a0a272d3a01f89b62c87c1d9a5f03ef219e9e70e5702e9cbf1198796c75e" => :mojave
    sha256 "c40b267f52bbf95770976b775335da1351748cedda7d5a559b999bcb2349378c" => :high_sierra
    sha256 "f211809477bda5a8723d9eabc253d7115e0705c4283655d6c881040aac79d6b2" => :sierra
    sha256 "93c9419e279e5b9d05b8df7101aa68282d0c6e83b78b9c7c0d6e813d9ee95319" => :el_capitan
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
