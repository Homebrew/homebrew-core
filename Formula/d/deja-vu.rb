class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "9f2b9286e0f94548576938cd945f68914367789346db096ee75387af663b6ea3"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8566182101e3555794cd86181f7f79ab3d22d483e9008632f3904a661a5015a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8566182101e3555794cd86181f7f79ab3d22d483e9008632f3904a661a5015a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8566182101e3555794cd86181f7f79ab3d22d483e9008632f3904a661a5015a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8f99eca0ea8a7fab07e15b01c2aa09f750bce7d6374149b77409fb0e19f64e"
    sha256 cellar: :any,                 x86_64_linux:  "063c127c8679446c0907482a6ebbc9a64fcbdaf7fdbb5b17bff9863d2186742b"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
