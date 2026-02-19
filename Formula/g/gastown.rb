class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b633b69592c207f200ec827a433f30dcc3d7b018bebc57dc4a2de59dd2d5d6a4"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f082bd60fb805a47bff536b929a8c5f0a6929b89504c4d8dd43b3fd8e55cfaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f082bd60fb805a47bff536b929a8c5f0a6929b89504c4d8dd43b3fd8e55cfaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f082bd60fb805a47bff536b929a8c5f0a6929b89504c4d8dd43b3fd8e55cfaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "afafcd88f454be7a2d063e316a721b4588cc50115608141378e66f68dad1cd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "818b6768ae6a957c331ed27d60cf2af27b17c7c7ff28fe80c02283aec91528e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df77064672fa2e8e8096ad251adc404e66430249a77db74bbc9aa1257cbde1a0"
  end

  depends_on "go" => :build
  depends_on "beads"

  # update timeout for `bd version` check, upstream pr ref, https://github.com/steveyegge/gastown/pull/871
  patch do
    url "https://github.com/steveyegge/gastown/commit/991bb63dc0181d5d6356d52a6319d70ff1684786.patch?full_index=1"
    sha256 "2d584793851a1ae00e71a1fbe77512c84a33b3d0b81e5203e92cc6c11d0f3bdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
