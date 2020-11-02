class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.40.1.tar.gz"
  sha256 "c956b8750f8df440a70617e4dc1109d6f17e19a51bb60a64fc4681b83c8aad48"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7c407c60bc26aa7a14d46daffda4d02751d9d572d77fa08f4dc716edd8975da" => :catalina
    sha256 "0f5e4acffb90cbb3e73c36b6df032865cd3d6116faa38f47725a2fe19f8ff4d4" => :mojave
    sha256 "2bf897c3d0899a46cca114fb1ceccbd4cb1d281d07e847d2c56b064d58d6ed2a" => :high_sierra
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
