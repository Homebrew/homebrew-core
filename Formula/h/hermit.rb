class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "670511fab89246bd71dbae3e3c4dd59d4ceb1ae23dfc37f44d8aeebc37e79540"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcc617d4f0367370865db50f9ea8101cf0e11aecb62d2d77d374a8ff874aafe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4605af0b62568cd7da6631b53d157e06cc06124d2dc2fbccc99fc1f356c187"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ced6c3fe0fec50cc248026f3840e82aea31783ff4a44a972ab6672e811170e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d43db87cab2e34fb81a11316399c62b5d6ab756090b82c8d18537aefb1f192a"
    sha256 cellar: :any_skip_relocation, ventura:       "7d9c07ee96d61c274914a7286aea6733793a7979287f03ac1eff4848f62f7d24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5895ab3145fd4510b793928166ad6c53d0795cd4226393e19875c264a32664b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e512529f88a47b74269e237fe595c72e91672bfbae57e112325865410233a02"
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
