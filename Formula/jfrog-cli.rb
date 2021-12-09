class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.8.3.tar.gz"
  sha256 "545e24c328112e29b80d71a498934ea3d683af0644bdb216edf3695e1dd59c8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61bc6416cfeab584a3c6701f17be3ce269102f438e0372a09de3b29b312abb1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585e6445e265ae0cbb935511e8cf0462ec505db356a6473fbd291b569117acb3"
    sha256 cellar: :any_skip_relocation, monterey:       "68557e0f356693ea14622e97936bdb45ba34b8ed2519059fb0a0dca81164c3cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e9e864c7c372f970b3546663289e87ff70aab87c45e2a84cb1cfa4db84e76a7"
    sha256 cellar: :any_skip_relocation, catalina:       "a0c7945fd90b17aa1604dac73547905c81a4d48b995c7ffd1c560f3659dbf6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cde0a5ffef0dad83430fbf8842316e1610a83964929e4367745743c4e94c7a"
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
