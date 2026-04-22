class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.2.tar.gz"
  sha256 "947d7521ecc987fe0a839ab2c62bc0daad366a22d15cae3038651a5e82dc825b"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "133326e65ec8e5825e39032146557d3f19d0c165bb4c4165c5d29054d28ea1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5496a24360db3dc06d97c4fa01c3d00e0e51c622ac8e51516825557d22ccb446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3636dd76c845b50a82eb9727607a0f4497fbca18fb2a9064272ab50465b8535"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ac58620262ef68d027957e2c3301d56de83d868733c32d6119dbccf9f3ba020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6459e9f6da8391b2ec1f535a8c34f0e34f85f4d5e840a3495c521807d3c85e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90ea5b8abf5041d9b1fbaef679ad56f0493d3319928cac2180487710f7a01788"
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
