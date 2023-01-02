class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.1",
      revision: "5e7063ec11bb85efcf8e0c152dcd7dd674ed2d90"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52a51a232e4b6531e2282620418f4e1a09375a2e890a27d29447cae5eb698f1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f73d57462731b4415367d672e832ad452c4683c753207c0923a368b3c359bb2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "023555217786fcd227e39aabb7209d9c49fab84fbbac5188ad74e3f43a842783"
    sha256 cellar: :any_skip_relocation, ventura:        "5cd1dffc62969f3f8e71b9e10462f62121ccc3db7a4dba9d7151fe90a8e999a5"
    sha256 cellar: :any_skip_relocation, monterey:       "edcd347ebb4549d1ffe34290b5efe04e027b24ed9ae6cd9cd1ac49783b4802a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "93edae6a0a87aa6343b3a05f10168a93baeb40420d1739c2ec739521d982fb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27539753da77d47703c9b84f0490c0d94c06d3c4bf6ef23dafaae841d2566fb0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
