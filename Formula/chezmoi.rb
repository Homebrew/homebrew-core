class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.5",
      revision: "53bb61524468afe3262d6d8089fdc6912dbccb34"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2d237ca5d3f23c68f04e81ccaffe2ecddd21308b295734f1ba440f2d79a3e8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051f985d3837e99dc9cb84255e9b84f6f3f33180824bea7dc263f3fa81d12ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "bf52746628c7b2d1267d3b306e284c96972be02463073e2e5ff01b7167d95323"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f8048307faf63644f8a4b88f31a5a345951db894fd4cbf60eb034317a958a7"
    sha256 cellar: :any_skip_relocation, catalina:       "6b7a5d14f06a13abc1a50cf491d4d73add8cfff0afa5ea7585d770f2f9e8ec6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805d43f8db58f17f8e0d404462077a9e66c992e22e6412e6ffa139a598777280"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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
