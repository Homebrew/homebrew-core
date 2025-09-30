class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.8.25.tar.gz"
  sha256 "2e4e1b61ea4d426bbfa615cffb847ed866ee8b8477f114c648567fc7750c482e"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b968ff3fe5efbc8be972c45f1cfd23aac42c19667d2bf69b8da10c6bf5b9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d661ec8eff034a6043e72420ec078a0a25bcdbfc0c969e5e481d82f9e85d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4772c693a6584bd9190b088f94d3be4781c57d23865a84ca54721fe7eb0fce05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86fd46e6ffb63335f977e0a9362dbb3e69c6941841e8a719df27953a45703c73"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c518b4743f2bababf152ef1dd8c998143ea9778b0f6792f0e7d976b96261c5"
    sha256 cellar: :any_skip_relocation, ventura:       "2a982c98041d4af72e1c8d1cea1680525cf1613f9b9cfa0031bc129fee21fbef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436d0a76a19bcc3926e694efd34d3eab983a24ca8249bb82885a851745c4d2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a870835f37453236010288904df5d1a6c15a245da05d7e8782159dcf86c5f9a"
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
