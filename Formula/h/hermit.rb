class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "64e81143367ba1b031d28ac0b5cf7cea1cd0ad8feabcdecdb5265dfafc078648"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fae4bcc89510cfb08b2bf734a1131940aa0fd939f2e4371f4780d81a8a070b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11fd6236cc50ee4f66068d032bdb991e1563823eb03794066579acdd276b3aa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6252b663ced733184bec2123f11f1faabd80af7c3dfb24c5b5cb91a84a7df7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2253a4e6357c26f29d4e8f32427fa21a2a0f7bbb87b4171a5de9c4a65493c33"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7945c3de2dc0ff4a5c13829c00d77e428f54e08d3060145cebcc70fbfb356d"
    sha256 cellar: :any_skip_relocation, monterey:       "574ed084526b0f0097e6ccb340dc77e5920acfaff2d33e48f2deb491eaad7908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d945dd8315beaa6634a57c8e7f224906eb05ff965d33625a7732d472ba73e8"
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
