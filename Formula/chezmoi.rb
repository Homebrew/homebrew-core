class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.8",
      revision: "7bce9fa6fb59734c1111469d6d7384b89f7024c5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce9cb84e6609bfb19f17a228daddfb5e7231b8650649a8c06bf9bbce66411d8a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a24d52ea44c98295e9f9b2357f8491b5873434cdbfd87c5bff1b1ceeef61ae4"
    sha256 cellar: :any_skip_relocation, catalina:      "360287b28946efebef5d4fe5d4bbe8cce75340dbd34db6201b74dc1fac7b9569"
    sha256 cellar: :any_skip_relocation, mojave:        "0b44f5d568d8cf179844e20246aa831fb397d43ec5988027fada795a1b3929c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
