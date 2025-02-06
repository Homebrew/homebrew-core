class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "af1244c07ff5f3b04d6a2af186a9f2bdd33044399c94a051b64162f238a6b8bb"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb13413b8ef9aa2a0adb3006b644c760f70d3d31318ab412b54b7657a1fedee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06ba3e7fe5598912d686dfae4b170ec263729dea8925b7e7710ce7fedd74ae1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a309ea68981e816ca98b28c5e6180ee3f0ddfb7e96e72db6ed1c8b3c89771df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48956c414aff362f44a13daeb8dc32bc102cc0cfcbdb4910cbda4752f650ffe"
    sha256 cellar: :any_skip_relocation, ventura:       "363184453b76414aba0258b7847d8570fa14dd97284720c1c68c1606ba05c563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f41637d77a6c605ddd0f92d77c042ed68b0a39d662e36d15d25c6d19fbf393a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
