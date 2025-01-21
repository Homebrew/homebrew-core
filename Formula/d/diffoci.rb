class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "c71e9dac5854a61240f82fd31e67eb993bd4340e91b6dbf47d1eba52720a1eca"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f3f9f0dfeb9d3dbd1f8dc4aaff3843ddaf5ef034c56a0673266f10ebc7169d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd31515137880ec63126e78d42a557167ae0e047d071b0ca2ca3909402d99fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dac9edf366cffda07ebab92be1735b70e248dd2c723b5edb167bd18ee52c0127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b21464f2d7d35799933ec1de2a432b3f10553f3c0b9f1f095e3ce158425ca52"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9101b986889a7c363159fd22ad74b95c4e3a52d49355a35f374e3b0a3f3d451"
    sha256 cellar: :any_skip_relocation, ventura:        "bc520a463b7536730380ebd6d5ee2e2dd9e0a37ed611b2328f1980223f5e1c14"
    sha256 cellar: :any_skip_relocation, monterey:       "25db3bd696e4c1bf6caf9d468dd84ea10889297ded14f8599c80499479859132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a9db815bb968bb47a10edf9ce0b4fe5b4340807fc78ab493147e7b98a82a00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", "completion")
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
