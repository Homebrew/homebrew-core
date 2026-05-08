class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.3.tar.gz"
  sha256 "a91c9f60cc04074505671ecff64b537d88ba219893b83fb06b3bfaec30dae8aa"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a6a2fb511c617b57aee0df618bdc6d5c6b81d6c8c6e71ea5fd4714ebf7fb824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ba243466fb9554e8210c5d3a7352e96d3ec73a1c73f693590fd6b917d4e09b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d838c6b2f44943caefe0616dc6adc8524ff7d3709a99dc9fb9e8a3f5c5bb7382"
    sha256 cellar: :any_skip_relocation, sonoma:        "15981c6206f68834c5fd47a71733dc3b7d208cd5f73a5327a1fa66c498277d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91be8438e11a34d349fa4398bfbd389659004942a9bd26038ee5410e8e6e3caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e278d501caebd056a99cee9d7e94c7c0cd9c2e84259c45c8fde3c0ce80e8a04"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
