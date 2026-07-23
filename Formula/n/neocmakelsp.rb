class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "c36516b48b018ad25f3d97f79f346f5712b02365e800b87b8ddd3292245c8f46"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a14ac3197919ca82af3060c2db94a88891a5b593d0a98c862dae9bdc3c203059"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd6ce459f78c09b2f1880b4ca80a6468583960df1c0a8c42238ebfec64045f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d06b33a63d1bf8ac0a28c9219da12518f60143a0070c1523b748a056bdca87e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1544b9ccbe93da023bc3e415ada2e89875d19aeefc801012d921929210e3a6f3"
    sha256 cellar: :any,                 arm64_linux:   "beb924fd39bcc93f6294352d25e34aa2a09fb3fc27c6af310cd3d50aaea4a64b"
    sha256 cellar: :any,                 x86_64_linux:  "0beba4f31177529d663530e97bb26b95ecaf8dcd70308d1138f90caef570f2e8"
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
