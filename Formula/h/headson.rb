class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.15.0.tar.gz"
  sha256 "e4827cc738a30ac1be38211c72d5c24c5a3661ffa9f13e62ce6ad8a4d803612f"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff63d126952c5c6e7f660af96eccf755095788f2e32f119ef10d606e4fbab549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d83b9b9566b901bd0a544be68669898e556197b85f48b20d11fec32d5ca5119e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0ac99cbb9a3f5ff50f5fc4d8666ef5fd0619f9c85d97e884e1722f88ffdae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d9178a9593e6b7029f4cf415d4a747ab946ab34742b651e84e712a10c777aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed30aceda83351fcca806db9c46bc9bb0a83302fabb626365eeec3f1d936db1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1fb9c39a5997984b3add31e00e340188fb5eabe39f13401602b20d0cb4f048b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end
