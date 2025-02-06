class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "074423ba79c4784704d84f1e31d80d4666723542a0a4d08d313e0ba7d44ed10a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66bc204347a73b68331e2a3f3f0669deddc756a7882f0876c7abd6dc22978c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285121b40cb14952ce0db14c3fd16a3377400a6503ebd79eb2057cb2c6eca047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f95b5aafc0122ad428969a1bb73d367451d6c8f6419603a78d52cfa380cdb76f"
    sha256 cellar: :any_skip_relocation, sonoma:        "64986f0b15d1ee627f9bbc68f0ee87bc5a97a1b3c8d7740b00e138d19ec68d93"
    sha256 cellar: :any_skip_relocation, ventura:       "c995db892d4f29d23b3500f46a510c7681f312ecb7fe3e80c4bbd0ba76453d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0806d78091a3b50b3a6e4206423f5a13ed7a2b3ffc9cba214e51d6d5a274455"
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
