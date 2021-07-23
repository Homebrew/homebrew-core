class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.1.1.tar.gz"
  sha256 "8e5378ad01471a3a030d9f6b2bc01468465b5e0e25009dab2d401cb5d2c4b36c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0ca1cc2ca2542493f8b268cb18630015d5bda78d37ea6de6a9bcf1ee22b8be09"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b925641ee364c167a8de6d371ea6de745e219407f62589c29adc8d73c8d3b22"
    sha256 cellar: :any_skip_relocation, catalina:      "46588b39bfa045ea760d16747dc5be12ef6af146659f73e0c3fd3290e8a5704b"
    sha256 cellar: :any_skip_relocation, mojave:        "e02743a62c3801141640b79cda1c9a27105a7a1a52b038e8f47c69aa342e9c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd426da920ffd91594fbdd35256ec2e9563c45ee4014b59eb0d23615a47de8ac"
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
