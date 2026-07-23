class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.67.2.tar.gz"
  sha256 "7eac03bbfa2fcaaf9cf50a7a26432c8b1a63d7b86bdff93caad884ec7150ea68"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a16afc651b7c6b8c862e4af9217736ec05a5e9ad62675040a54ed3a2d4c11856"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a16afc651b7c6b8c862e4af9217736ec05a5e9ad62675040a54ed3a2d4c11856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16afc651b7c6b8c862e4af9217736ec05a5e9ad62675040a54ed3a2d4c11856"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcfdb70775f327fccc2bfe6c3443a4828d2fea5aa0578392df06d680e9998bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78e419b18aac20934ca9db40d8ab1346714b366c9b770d0977096d0ebd8de307"
    sha256 cellar: :any,                 x86_64_linux:  "bccd2af1e2d9a39f255d2e7d492fd8c0f2ef1d294af3eb6ca585e72031c918f8"
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
