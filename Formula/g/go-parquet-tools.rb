class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.2.tar.gz"
  sha256 "904840fe64188ff6e61def5b34bcfc006f5a2069562eb7224f6f67d88d8441a3"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57c7f42f18b631706fa57cb1ef65640daf3cd9f21144b7438994afb3278c7cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57c7f42f18b631706fa57cb1ef65640daf3cd9f21144b7438994afb3278c7cb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57c7f42f18b631706fa57cb1ef65640daf3cd9f21144b7438994afb3278c7cb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "429808e5a0f5c1467585df1d38ce1a78392576b29237018e508f6368905357be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31258a25e3e5d6de6d8ae8431d8874283fdfa674256d482d790e5f2df6795f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c2cb983544c646ff14ebe7a2536ba2e238da402465f7604aa37ddc710aec5a"
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
