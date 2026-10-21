class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "eb88d467816f67c22cfa864f3d3ecc4eb5cfbc1afa018fac61a23915f21745e6"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4deb2f49ab382cbf77fb5e6d0076e034484e131b7571bf74923cbb3e8f206cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f749f0461dd6b7e001bd1b3c67ab0dac17b5f27221b092f459476da74b1b43b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96bb38cdcb892308df24b1253c30e2355006bce9b2f22032f2ebe61ebd7ef13a"
    sha256 cellar: :any,                 arm64_linux:       "eb538986b4ae959657d3b27330b12c5e94a50d93eb48e10b095cde2d3766b9eb"
    sha256 cellar: :any,                 x86_64_linux:      "1a85ff2f5942930d606688fdb75830d34f9126dad8e30f172788901f7207bc90"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"neocmakelsp", shell_parameter_format: :clap)
  end

  test do
    (testpath/"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin/"neocmakelsp", "format", testpath/"test.cmake"
    system bin/"neocmakelsp", "tree", testpath/"test.cmake"

    version_output = shell_output("#{bin}/neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end
