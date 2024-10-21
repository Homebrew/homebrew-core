class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "330ee3826bc686135b8c6e3ae764e27fe2e446df484f04d08fc90bb86beea9db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07dc2c7c6a3327033f61755f0e4860ee1e7972ff0643b576fcb03b14bffbd629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8da34bff41a7f5c0c4e738e5ecbcb1184334d307cf0046eb9cdb1c1976b1d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b680e7d511afdebf205f0b51be756a7f92079a48ec5a8cfc9e511ce38fbd94be"
    sha256 cellar: :any_skip_relocation, sonoma:        "5268f3ae0ed4ce9dc0d54ede0bf21a88924cab70be595e02ae8c476ff35faed0"
    sha256 cellar: :any_skip_relocation, ventura:       "092637f88e7638750b7118cf4f0b3688fb8b314116267b16d8e01f659fbf15d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ae0e9f614015f43fea330c98565e51e636147ae12e2ba61afd042f26a645d5"
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
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
