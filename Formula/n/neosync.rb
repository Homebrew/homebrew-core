class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.82.tar.gz"
  sha256 "6cce2036bccd7a7351369e3c17f43ffce3d96864b63449b60651a6b9e213bc2a"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "302107ede2be148a6622067f39f02e32159934b59cfec875f89c9d588de569a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "52ee734a45fdfa146cae4f1b8934a8e3a838977e03687b67d854117233c5b877"
    sha256 cellar: :any_skip_relocation, ventura:       "52ee734a45fdfa146cae4f1b8934a8e3a838977e03687b67d854117233c5b877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ff540abe6ec38bab7e5d9de61d99501ec73a76123097a6028777b411528a09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
