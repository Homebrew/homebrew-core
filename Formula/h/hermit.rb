class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "c33d79a87f9e5064f7f1a63404e0dcf7c95656e77ae27864642fd92927b63de2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8cfd3891d2711ec30c2eb27b5f4d88972f7ff59b977e7d6918d4eb742b8466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eb3640570cbb146b8d14c22db4ccf50b73e2580cc0b581ff2a1911a42760a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b7c7d65845e4fda671759c798fd625505f304433e3a71ba93665b03baf418a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9b080bd8f3ee8e3455dab27afdd12a8ed2a3314472f334dfccaa60e166ec31"
    sha256 cellar: :any_skip_relocation, ventura:       "7078fa91bbfd74301f4abf3ca77f9f7d826e4868976b516220d2a2cc9619a104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f85f41230f0abba0c36974a9df152f73c089c577723c90be8311a6809f1190"
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
