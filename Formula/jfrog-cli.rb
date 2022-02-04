class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.12.0.tar.gz"
  sha256 "4a524dd36165ffe992b80cb81c9a80ab027158319fba1b828e2a0e3ea53a77d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93278c5b45621dac3b4ac40895d2bf50eac5940fb6990d550352882c7e773a9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba258ee7164324232480621e85a237981c1ac927090048e5f88f99bcd6b23f71"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f16468e5b1579c7a3134ac379f0197e5252b124f3605a397d1f347a8cd397c"
    sha256 cellar: :any_skip_relocation, big_sur:        "33e3471c66a29f072cc30c51489ec51d7f4bd6d3187c670a7a42720078c6222c"
    sha256 cellar: :any_skip_relocation, catalina:       "e4f2508a7c5f09c944644b0525de8262e6962a5a47907a75a6b843fe1ee60e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9358934789f7d2dacbe19f9ae1689eac711c5544372a643ffc3765fa654d825"
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
