class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.80.tar.gz"
  sha256 "d9d9ad9ab5081c51b70dd18ac4efdfb2be291b77597bd5dd3ce89237fb541651"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "532cc5daab0291a95649dcc246285a6b32c5bee06e13d0678309efbe3b012aa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532cc5daab0291a95649dcc246285a6b32c5bee06e13d0678309efbe3b012aa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532cc5daab0291a95649dcc246285a6b32c5bee06e13d0678309efbe3b012aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d23f8c34e9e566c5d025dd6fa5e8af4a255d31d2ffbac744e7c79f82fd5e4495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6d752f3c5fdcba44667e38a409ca3db62505ec76aba6cbbdbbb404af24a7e8a"
    sha256 cellar: :any,                 x86_64_linux:  "93f4a3f10fe636abf6ba6d494e7515d2093c0ea2b2fef8d96a8b404ef7b782ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
