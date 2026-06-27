class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "c87b4020aedf247884a9a8f60234de669490598272947b8862783efab39a56f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f9b71aaadf56139d10d9942f03b8750e68ebf85e479e957aa9f1b82c2e91b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78271fb3791e98127043a2efa806f0e572bb5bea5900501701a7a65a2b8e8147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc4cf1b68aff9c8388a933199fb5a5039cd5aac63c5259ea71e6a175ee7a77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce5a219aeabb304e177932b09a8104c7bc8385eb20275a9e3bc8e64d3d1ed49"
    sha256 cellar: :any,                 arm64_linux:   "f615e2038974db3ae5bd13b3e4b3e89014149761bd4c603cc699a30a0521f733"
    sha256 cellar: :any,                 x86_64_linux:  "b89f085b3af3f80da40a8639822a0fc63d40510721e98ee487d5d7e123d8abe7"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
