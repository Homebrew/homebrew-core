class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "eb9ce717fb298f15ea709c240b1800b11d543e81d2e496067ebebe036cca478a"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c158a8a175f81196bebef89ccb5d0cd4a403ee14f9063246321c74a0976cb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2c158a8a175f81196bebef89ccb5d0cd4a403ee14f9063246321c74a0976cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2c158a8a175f81196bebef89ccb5d0cd4a403ee14f9063246321c74a0976cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "305254baf6d8efe571aaf89d3b91fa3ff1b2f0d5930d7e8ffdcefc17c46d338a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a6cd9cafd27702596fc891e1f704699f16816f636edb96d80bb8f593fd5f3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2321bc0fd0cd317b04bf97ed5633eac9a52fcc2b9317f2152aa15cee26b2a0f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
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
    assert_match "name=parquet_go_root", output
  end
end
