class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.11.2.tar.gz"
  sha256 "cbc9bed24757fe4a3746a7725bea7356703f16070b00cfabaa4de3492d93711a"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd145c7f5cb55e4678596f4a36cd1f660696402e073bf3271c7dff71cbe8fced"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ecbb35d4b4022629d5dd3ced3c904b14d2e68fee0beb938cbfb1e0eccc0cf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d3bd3682450c706284af8b288e69f7ee58442cd6e4de77382772d2840cacc92"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d2ce6d60b7efc4fc2f9d0d2ef9e6517b566c2eda07e2a016f03f220da7bad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b3d6ed4c8153f75074cdf002e8a945d3fdbbea76b5e94e1283bb76cd57623c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f4b422577146985ccea8d5e1a18060b08917c5d1f075f80698b52b7adf348e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
