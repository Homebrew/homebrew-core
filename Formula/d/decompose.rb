class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://github.com/s0rg/decompose/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "c68e57eb98d88d4d4221147229839b753b20640da88992b1e6ce143aec51459a"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d71ca6bc293b1e9a262748b1cd755519c86d18df10e03f0b535e85aa089f9eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71ca6bc293b1e9a262748b1cd755519c86d18df10e03f0b535e85aa089f9eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d71ca6bc293b1e9a262748b1cd755519c86d18df10e03f0b535e85aa089f9eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd73eb4e7e3e628dea303d47eccd83844c41e17a265de442cc95c901ea5528c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62738aee22fbe289af889ba818ed0d152bac1ab2f8cc73b68394658b05ba0b62"
    sha256 cellar: :any,                 x86_64_linux:  "60ca2687a4003079b52654f7b044efc0f7afa690203e91b6dd76e814b03a54bd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
