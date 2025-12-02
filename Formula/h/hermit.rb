class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.46.2.tar.gz"
  sha256 "265c13654f9721d750d288106caf4fa638ff482f06888ccf933d1f9908759a26"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26644aa7e7fc0a3283b3f35c8a9a22c8fc04912e2586cfb02153abf7e49de9b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c77bbdd8ab3b385c564ff9ccaed7454c05ecccee18ceb08efdcb3ed5958819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2961bc954b1c0b4373d8ed250af2a5494ab11d76eb9b7c3176ddd97d948895"
    sha256 cellar: :any_skip_relocation, sonoma:        "5774badacb689233c93ac1af369ad089d426c940072de194467a28eb297fa094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bdba71dad9894634a91464c27c02e7db9b749d4128dd1cd5051cde35d8de4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b00353a49a3dca00a72519b4f4399f7ee1c6d48a2f3330aff7feb7e013926a3b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
