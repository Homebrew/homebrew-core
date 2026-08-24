class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "28fedfcd4248adda29558fb45ad6c368ef5232edd1ce3285d9838abe3701aec8"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3612be5297a09b7909aba8c9d9189755895438ff8b13f8d65ea25b23934881a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f6fe5c0688d6d61a7ca3c34ebb78327a94c3c61276a806e582b930512523589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a57d9bda33515dbfba13f95c877986a2325bc6f830077c5f73b2cf5e652dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f44d942d043ce4814c0943f95a4928a8719e91469c0e30f00c1d3a45ecab7a"
    sha256 cellar: :any,                 arm64_linux:   "8a50338edd3b5b20164d63526cc39f2a1cce147e53fe73957c7d539c991c4015"
    sha256 cellar: :any,                 x86_64_linux:  "92a3ff23ee7dbf8eeced5be4ace30e1aa01a7071c59f6c36f4bfc7690d0003e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
