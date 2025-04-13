class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.22.tar.gz"
  sha256 "ec6c505fd74b5160c29e6c52bba4c5835f5456bf39983c105bccf0b0622bc72b"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb3619688ad4b02f867457e092ebf0146c7bbb3ad32058a07f991076e25ecf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a46e3731b8322e9e43b6fde818e5a7a586dc0ae8c0611e9ab712ec04188a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0334e33cafbae620b3305fb03af12d4514ee0bda56d4af26b5ba9debe2de542b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f285ffa6b9d94b0a6a005c79e789a5b489ff2b287275bdb8ad2ff0f04da97b4b"
    sha256 cellar: :any_skip_relocation, ventura:       "74f8d6ab530803bb93d8a4420a93ecbb8836fde242d6649a6412fff30438bf69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91fef34df832f85a8160a31cef3c9ae09c04656a4387b695819961de21646e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ecbd9c2f45d26d669140399461b41e23520b92b8a1d21310868b5c294e5b7b"
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
