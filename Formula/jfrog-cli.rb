class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.2.1.tar.gz"
  sha256 "5e1b30cf347def2ba5338daaa99504eb6c0006af973dab5db8cde87a3af29991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a0acce8c8ae2c57115546ce74b5d02665cd95128c861a752279d5b04539d36b"
    sha256 cellar: :any_skip_relocation, big_sur:       "30805688b70cfe09a133d0fdd4aaef3eec0d23252bd02aecd7946e70fa66b60f"
    sha256 cellar: :any_skip_relocation, catalina:      "ad77c5001e7131926d57b442717cadf1d3777a8bab7b452e49ef569572a9d25d"
    sha256 cellar: :any_skip_relocation, mojave:        "f34d1cfb6d41317add7c5cb028954a99d59c3ff32550697b4a88d1633191c3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f329a4732efef46962237f19779bff0d0aba58436abfa56eaa8fa4275f5d9fd0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
