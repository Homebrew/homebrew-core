class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.62.1.tar.gz"
  sha256 "b16f43a8d3f6264a611a3507455b362e75742770b796299d9710ab4638e84e6b"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51acf9bdb78047f9d78af341c2010a880e9d76b8ea5517d0b1d61b44733379b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af1ae7d5fd418746b9db2424e44fb27c418309c505a7ca5e66970630cbf5cedd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882195885e26648e02d08058a90323af3e86dfd456c18d38fd1ed10b3291e09d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff07ea870f98df575fb0eecf85eb43887c8650ec7595e20b0061197ea8710943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3569f1958cddeb6e4b8262e63ac9425ed3bcdcc9aef1c7f16514855839941a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0532666438e27ca512edd9dea24f4f0f3064bca7a852ffa4fb2cd5067db1847f"
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
