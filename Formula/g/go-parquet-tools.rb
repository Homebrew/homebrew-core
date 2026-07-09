class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.52.1.tar.gz"
  sha256 "9fb157515508a6d86c725088efdddd2d56f75c2cb172486d8308788ebf61ac2c"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "131447fdffe544a6b5d184bab4891592a8dc0a31fa6e6a383fc1a8a76cfff2b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "131447fdffe544a6b5d184bab4891592a8dc0a31fa6e6a383fc1a8a76cfff2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131447fdffe544a6b5d184bab4891592a8dc0a31fa6e6a383fc1a8a76cfff2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b55f0e34492d1885ac769d2cddd6ae80c939c7ed366df08fe282d167abd282e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3c40deac35b488d9d4368e4e0470ad3d9c0722453fcb57f8c04f95b953e003"
    sha256 cellar: :any,                 x86_64_linux:  "5987fe3308bac36767d0f71980b9ac4929c871dfb757d6351fe4a5b85609f93a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end
