class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.9.0.tar.gz"
  sha256 "9cd3de5d5675ca79ff7251491c481f6afa54aa6a68bbbbf92613d66bfb39aa08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5af47da793d997af20c568b40714d623013d21d93ba31598f4f1758284e018b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2bfde0fc6248f7db514fcdcd8eef4fd6612e767d5672741828219115a414582"
    sha256 cellar: :any_skip_relocation, monterey:       "e418304d4bfafd663ff50ec67e7a641711313867b37f9fff1d0ddb41685b4ca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d508c41fd0c5195e2dd2aa10aa5845d09064411e017bfd21bac798cfff200ce"
    sha256 cellar: :any_skip_relocation, catalina:       "302379a36dc2ec68e9be83af447b89b891ee3e6a0998cca1a73234b0b67d0745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028ae8d288ffe7eb7731f40d4e4687062e0e756e6c94740c093d2bfc22a98ecd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
