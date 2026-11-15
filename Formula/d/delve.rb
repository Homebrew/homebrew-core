class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "8ea5979dfc5978c9690dc1dd533a830815441dd33617f4a61bcdff7d2c3c7e90"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b95af1ceba96c075ff60bdbbd7ba5ea120a0f8a73cab85a47b123d3cf405638"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b95af1ceba96c075ff60bdbbd7ba5ea120a0f8a73cab85a47b123d3cf405638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b95af1ceba96c075ff60bdbbd7ba5ea120a0f8a73cab85a47b123d3cf405638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2b95af1ceba96c075ff60bdbbd7ba5ea120a0f8a73cab85a47b123d3cf405638"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6dbd2cb7b11055a81966f06164d73b8143bf1430e21fc78d07a91767c9951c1b"
    sha256 cellar: :any,                 x86_64_linux:      "a15fd6e27bf78aea43375733c495ecab278c090a4ea11bb9af9d43564594ac39"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
