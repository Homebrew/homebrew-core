class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.39.7.tar.gz"
  sha256 "627d8f69c26b698b4d416016db76b2b6e5b5e2e8834fcdc31d20afdad23c19ee"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aa8616db8004b62e3d9de3b8b1dceb790a8c51832f4a4417d6280d4c47f0f16" => :catalina
    sha256 "7b4f709ec992f4e2c6d9458e1c02fcbd9c58138a5c8bf4be07d80340c53342f5" => :mojave
    sha256 "a1feaf504ae8bcb9eb3b530fa4d019fe4dcdebd5abb508f97fda0008d59f27a8" => :high_sierra
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
