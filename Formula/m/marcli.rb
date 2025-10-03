class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://github.com/hectorcorrea/marcli/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "944c7c389d384a9515799bb688cb9ced80344709758a42c714f726957785a1c4"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76947a31b32725929e5172ca3456da7061128f7c9acd0c2de54c3b344bf7fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2152b85bd6b2a00ebe84d354e0b09066a463a4442d3478529513021b63769216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2152b85bd6b2a00ebe84d354e0b09066a463a4442d3478529513021b63769216"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2152b85bd6b2a00ebe84d354e0b09066a463a4442d3478529513021b63769216"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba05203356da269bfb3f6b89e0fda85562698c63860bfb036f7e1335c0e0dd2"
    sha256 cellar: :any_skip_relocation, ventura:       "fba05203356da269bfb3f6b89e0fda85562698c63860bfb036f7e1335c0e0dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43204fe80171a0721bddc9ddd40d75d2936fa9accd5e0f3eed1f3d1b2e2c989c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8569415a2de99dcf9476b4bf9b9d8e0d5c738b17c386e017a74f4b53887f2a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/marcli"
  end

  test do
    resource "testdata" do
      url "https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
      sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
    end

    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\n=650  \\0$aCoal$xSampling.\n\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end
