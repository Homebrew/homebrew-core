class Cek < Formula
  desc "Explore the (overlay) filesystem and layers of OCI container images"
  homepage "https://github.com/bschaatsbergen/cek"
  url "https://github.com/bschaatsbergen/cek/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "df2e264e15b7e5d2d72146090300ad6833801213e552a55c9079449d8b8a71d8"
  license "MIT"
  head "https://github.com/bschaatsbergen/cek.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b10010fdce4faa68f989566361610541d90f81c5719029820344dc43d619280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b10010fdce4faa68f989566361610541d90f81c5719029820344dc43d619280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b10010fdce4faa68f989566361610541d90f81c5719029820344dc43d619280"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3cf706c12e49fd12f6d7c3c6a710fcfe5e636db04e5abe8c249501d3d5ab772"
    sha256 cellar: :any,                 x86_64_linux:      "0c22acf4525cb49c49ccfed04345aa89badb63ffb627ec7f7e3f0b4d3964ac19"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/bschaatsbergen/cek/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"cek", shell_parameter_format: :cobra)
  end

  test do
    assert_includes shell_output("#{bin}/cek version"), "cek version #{version}"
    assert_match "localhost", shell_output("#{bin}/cek cat alpine:latest /etc/hostname")
  end
end
