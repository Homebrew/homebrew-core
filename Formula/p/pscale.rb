class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.256.0.tar.gz"
  sha256 "b83c7e9fb9fba2647949da19530b85b633869022f0b15c64d92d002b60d71036"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da40136aba611ac15d057d2f4388839dd5f24b08ccb933aadafe9a1c52d9c278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2269352699e7d61273b63b8c741c2b405b78037ef3ed87ea438d35665c232955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3db1ba4793021b3110f9f80c28eb22795534136fb72e9fc39623e1c4394cb10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0f7a6395256ae20d9cab0f3466898becc6acd19472b9f4cf0f3f38288fe812b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8737fd12a4e1bf6c553b1750493f9c98e05631dab380d6752b5fe8eeea433e4c"
    sha256 cellar: :any_skip_relocation, ventura:       "23200754f150b01f9960644ee38c53ca56c089f91cae3a78e97dac366d52286b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2156c686d49bf2646ee8cb02e99f57c28e41cf2171842527818640a2fbeac5d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
