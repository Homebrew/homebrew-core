class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.4.tar.gz"
  sha256 "0f70602bce830be3c6b8bf5c0120b888b1c2135093674100df42112397ca356d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "079c31ddafe19dbedeccafab1075492087570fba7cb568f4b177f8fe9d1cbfbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "079c31ddafe19dbedeccafab1075492087570fba7cb568f4b177f8fe9d1cbfbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079c31ddafe19dbedeccafab1075492087570fba7cb568f4b177f8fe9d1cbfbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d87fc5402116f646e1c8ece98956f47c024edb5aa79f3c7bf72a0c0446086b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23ee5bef7cbaee47ff45f4aad13253acd1473cd87f182d3290a6b46313a87d2"
    sha256 cellar: :any,                 x86_64_linux:  "76448b925c4fb63f249c71d7a44341fee0f6bcefda7b2f535affea5d1e291d7c"
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
