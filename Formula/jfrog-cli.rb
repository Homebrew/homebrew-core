class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.49.0.tar.gz"
  sha256 "2135019d7b94f1848e3c47be006effbf22698278d5a30ce47687ae5451d36a0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c708837ea318241eebb16fef90fd0ed092f09b7b2141e4cfb17d7070770d389"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce093e3870b4e09956711f41d142cfe849f44251a11977c0d67b8c328bf1a232"
    sha256 cellar: :any_skip_relocation, catalina:      "12261b228997a8a6deaf597f4abd511379205de64f41a433bc650c139bf81d72"
    sha256 cellar: :any_skip_relocation, mojave:        "f739fd8dc4597a88e9069e91a982062cc4f749e310e1c641f9f46e5bd43dfa47"
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
