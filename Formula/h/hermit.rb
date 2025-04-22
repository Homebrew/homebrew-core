class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.6.tar.gz"
  sha256 "7a7de6f418e60f6c6178c101ced5440660df8e1ec28ca1839cdd8284bb9a5ca8"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22f21ffad3d175beac72070b2952ba2dbd0f7b50d8befd5bec794161a0601a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50e07bac74b371dc4c8dd5b6d05d912b675510f916f21cc079c6033f6f07da1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60dd36a615d15185688045ab5d18152769a3d84243be37aa6ebc0a06ed52a039"
    sha256 cellar: :any_skip_relocation, sonoma:        "8010ca31f5a35c1ed0e519f60e269b8e7535db3808d945f550808346bf4da604"
    sha256 cellar: :any_skip_relocation, ventura:       "803d94e84b46f045149fcb80218b9e392770ce42a4c2f236de2e3e7d7a122725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "497e4b750b1cc679ff84ee369079471f4a8dcdc764328eae5334c8903c2b16f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02e929d2e420fe29bcf71cfe7d02dfb2f82863ffb526ec9326ba90f7408d73b"
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
