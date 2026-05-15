class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "b07c132c6d478c388d3ef3c2601bc2b04917ed0c9732d37dd68587b5b460ba74"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d2e7c252146a68b0a8cf26388ffab317bc80b9ae36d7ddc7f415e3d71bf39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d2e7c252146a68b0a8cf26388ffab317bc80b9ae36d7ddc7f415e3d71bf39a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d2e7c252146a68b0a8cf26388ffab317bc80b9ae36d7ddc7f415e3d71bf39a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3d91d7f52f339ff6dc783a21b6883a5f6b430e7f126bdb88c72ae27d40c5c61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c30905742e5c0762be30d8b6e8f5327924f091f162bc6933c9249ff0dbfd4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb1bdee3af1e45115ebd8010258d8426f24f41af9da6afec99a1c4b641f3142"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
