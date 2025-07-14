class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.11.tar.gz"
  sha256 "1f777254309956ef6f2b0f38ad4eceb6aaaaa3c131aabc5c466d568959156f04"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e06942fd58952849c1a2ee8fce3d2ef89433f6ddedae691e5632aba12e2b32f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf0763df1937a59bb4b6c1bf701b49eafdb7ced1db42382b50ccaeeb88ab5cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ffbe17c41bb11f2b6fce370f4563b278cce34a51265ba6c8fc4006863060b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "a42a9ecf3bd1bb1323ad2941bec52b08f7d77c20aaeaf40f90c932e24648e8cc"
    sha256 cellar: :any_skip_relocation, ventura:       "a6bbf7ead1e4815de731d42325ec1214a1af3581451a53590226068838c3d41f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3172be38c8eabd14ce4d70252ed10ce9c24c9ad3603e1901acb3d702fc31b1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27a4b943ecb1486847a732fa777de743aad7c14094db8f8746d151f9d45f722"
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
