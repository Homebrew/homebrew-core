class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "5dabb1586e1797d409db4d398f5f612d9af9f46a1e805a9f93423961c8fa091d"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e62af12440fe5d7e6c9bdde512371eddbf07e9ac5a812cf887c98d06b1936d31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cd11205c0798c3eb765bc9f3b80bd6a6e4bfa133d2edce242709d0ecd34240f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7704418f51d7aff66015fa1c77b3c78d1e1208a92769f6fcbe3dbe73d32bfa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13ea65291037580a5c016697def81aa30d03c35c1cae13c3368800d043b1d754"
    sha256 cellar: :any,                 x86_64_linux:      "e20b7b7b395b10507291b820c071f33fae9c1b194485e8a25c17b8d108033ca6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
