class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "f9e8e2c8af2373188aba0ef031885a083dd5cb9cd5f725109f969e12a5daf8aa"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fe5a4734487d7ed88cccdc2ffa3243eb624f819a1127b895aabffeb7fd890a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe5a4734487d7ed88cccdc2ffa3243eb624f819a1127b895aabffeb7fd890a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe5a4734487d7ed88cccdc2ffa3243eb624f819a1127b895aabffeb7fd890a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "97194ec5de5245c7bef434fd2773097dd5035f8d12858bd51ebeca00e06a910e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "715963d6e55202be942201afd3f42801b567fa192c2be0205f40cc042dc2ed3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc516040300d4773476d0edb1a4c47becb2e92fd17524b22697babc3a795535"
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
