class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "49c79598d6cba99e65da5659637264e2020a8c3d8b71878ebe7ee1a5968a3688"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b0cb1db324e54c7345dcc804ff56aa67c6487071f89982ade6efd47b506b1ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b601c215eba2f7c6046671a98f2e562ebeed4274ffb529c06f347a24f7a4dbaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee0ddc2c9038444f9be9bb403407de1ed81d4c4b0370d4af8b884e7378645f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2e64f7e8b38a286aecf7842f5208af1aa14d0f58d18abe403173bf64a99def7"
    sha256 cellar: :any_skip_relocation, ventura:        "0dca546daa9b591bfee91e037ed4a5a105600d26bf3fd1a57be98a7875e68c33"
    sha256 cellar: :any_skip_relocation, monterey:       "69c6d00b58d95858c3dbb04c31e5cf536eada344fa8ac173ef3b5cfd2c5e8d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466544d691b3306ac32b4da41b3b992da058645d0e32195c2e42aa3d4ca15fd8"
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
