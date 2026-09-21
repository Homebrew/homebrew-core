class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.17.1.tar.gz"
  sha256 "7c04dbe3d94c8e828d453cfe93b68f0dbd25a72ce3735fc43d71e3e0ea2b9b32"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d6673bf3785a4613fb7e10e9d78f403bfb5adbc7143c9837814cfcb08f8f1e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26b23140a92e1f355202c6155a0119cc27bc317e543d8fe836e8bb8104b99cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52015f18417486bb5471f01dedeea443a4bd96f5c4a5d813b9b36fc53e02db28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d8763155984fc5e9e264596deaa8a2becc093afb0a8ede161783ab1d2fae70b5"
    sha256 cellar: :any,                 arm64_linux:       "a4f5b0f7dfda05b3da1e01cc1ff00b12c320d7c4e71a1c9f667137f9aae2af7b"
    sha256 cellar: :any,                 x86_64_linux:      "9fd4f1b7f1a2c8c41c129cbbd0372c346de6f7a3e92e240df889c32f80475f67"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
