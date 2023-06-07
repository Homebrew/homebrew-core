class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "45b55a75aac18231739dadc59d4a2001dddb3862680f75bb9d6f0db92c1b7c90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a4e41be4f85b8e18a2a8d8e055c9851b048254d90918d946a2d07357fb653c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0050a8f27cc010b6e92a43c34fc84962e6f3025f226b9bd3bf32447be70ffefb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c44a98caaf1e0697a90947c2d3649bbf4b59e9f6312d617f99c513e7d0f83c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ab6c703c4203f43bce917cec538b5ff09d40fffb3904d58dbf65f799c5daba7"
    sha256 cellar: :any_skip_relocation, monterey:       "98adb6c89c0e0071b2c5fd43cfe8178555189dee19358258bd49047b62aaf7d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e955051750fc1659fcfd4eeb3a7e4663513e9541e0472e28c6e703f4d83920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6da3aff2421c6db68ef70c92f8c773e03452de5e08d6698ef7cbe779d074f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hermit"
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
