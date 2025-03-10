class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "d88ba9cb58a9f35670bfee6fa42fb68e1b03b118a61568acef7855030a478c89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984aca55c44f6fcd457adfc7a97c543d405413308a0e3fb46618626798e8a97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c479d8aa14eb2a2698953ebf966ea657f84998a5d47ed88b62ee92017099f7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed68663e2eb8ca7acc2a698173bcad8137547adb2d7f187bab9f682599e63a20"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba73d381408029f3e13c26d8b4d854583ce39e89f30079318d91e9593cd07a4f"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac3cc497212a42ede795c60c4f4ee2237e618fb9a964abd361f85d436a6f90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0754c17b3ee71422e767ce81d6ce657f774469bba0961ca9c6720071104a14d3"
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
