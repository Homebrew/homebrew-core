class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.48.2.tar.gz"
  sha256 "382067b272689fac9f9edf293ff91941c20b7c45e58dc6d8d7330a7f08e81596"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c74402de7e92bc80b9fefc3ee26c1c3a3a846d94e200392fbe48da1c7ec49f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd272368dd518b40c6c1eb5e5fbc6e8f0431920c97dc1d852a0a00644ad4066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fce3341f2a5967c1afc9c9e1006cb2a996f5e7fec3d27f026d1b608086ed0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a0d6e48e9ecb694c96ad72e8a9bc6642c3f7c6b2eb61941ac2ea4524cf37d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb48b375400acd85bfd37871832c9f935766fb1077ec92a454f6d9a2b199d208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3850d2d0ae029eab9103b54a08ef7a48d6c7c61f5a3eff818e4c6349ffa53f65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
