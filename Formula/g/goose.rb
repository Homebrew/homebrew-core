class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "50d16c09bff51d7aacd5df97578877313d66f1d0489a42e055ae750587ecb5c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3117133c7f804429289ac870a9b976f4a0e57a8941705df7451d350020b42bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3feb428df1247cab46039e095b821f3bb392321cccb727055ffff61c78806bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ab08a5ce8af7fbc52b522b825794f81ac885131c0396e238a13ca8893ada11"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ff1b5c92400cfae24f2895bb78378140bcd0061e26d7cc404c171c1b46c3ff3"
    sha256 cellar: :any_skip_relocation, ventura:        "95917ac27a01aaf342049a4df13469976b86790ca144507a7c6ea9a64e4fc29a"
    sha256 cellar: :any_skip_relocation, monterey:       "9390bec34e3bdcffe97738269eb67dcfe6eef59e4350ad5dd1832d41ede1ec10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f102f1d4535ec8b4eeb881af0abe2e99355bdfa209d2d239d426a275970fef0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
