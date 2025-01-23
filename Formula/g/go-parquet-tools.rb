class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.25.13.tar.gz"
  sha256 "d587c52bfbddde2c29e72b365a1a9b963c5eea61a4d2ef91ffc1092f076c8f07"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5798c246c4a8ca48403cf95350d1607518b7d8dbadc583968172d8afab699d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5798c246c4a8ca48403cf95350d1607518b7d8dbadc583968172d8afab699d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5798c246c4a8ca48403cf95350d1607518b7d8dbadc583968172d8afab699d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1481104f1c54eda210dacbcbe01b73bd506a0cf921eb9aecea302f0a71830d02"
    sha256 cellar: :any_skip_relocation, ventura:       "1481104f1c54eda210dacbcbe01b73bd506a0cf921eb9aecea302f0a71830d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0d7148524e59aa0b691b9b7bcbcfe66e0dff662d40635f22bc79d55a987425"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end
