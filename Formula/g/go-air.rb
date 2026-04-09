class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "4322f6f331b2f8e62c7b2afb4b94c903d09cfbb710098cb2020ebdcfb162ccc1"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b475f93b371203e0d49a35998482f5ad82ec0890f4a09df7d0cb1641270b28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b475f93b371203e0d49a35998482f5ad82ec0890f4a09df7d0cb1641270b28d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b475f93b371203e0d49a35998482f5ad82ec0890f4a09df7d0cb1641270b28d"
    sha256 cellar: :any_skip_relocation, sonoma:        "33c7ea4186e5762a2d27443b105125232cff3935b2856792842de20623b321a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54390402dfa4b24043cb4bb6e91d9f1f63469be496ae1dce2a0b56c606ac375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067f61597a529e66b8a62b05f9a2c853304791da56aa203649b26c558b6c181d"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -s -w
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
