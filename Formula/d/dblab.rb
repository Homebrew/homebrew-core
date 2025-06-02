class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "58a71569c38dc6c331d30b9f9b71f99ae432e53f90f014192b45458afded5f4b"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735d628a3dc975dc2f525145876b79dd4dd9e7d835d80ffccd923b24cdb8d15c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f3149d9776e4690fb09bb3f42af66a1ab0844d85c274ea6a6be46558ef1399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8a73ee218e987738ec29c9deb767f7aa62a2b19b24101720c46db371a26ffb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e0e062bfe7c3164d9d6f0595c8110987deb52aa2fb95b92919233e7b6045ea"
    sha256 cellar: :any_skip_relocation, ventura:       "bd93f849d46873f36294087cb895133a07104019d32b0fa25d6d08b049d19fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bda69c0a881bb4fb054602419d21fd46dc6db6882ffbb39bdd42d0976a95c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7981c8c364d80f302664ed406b0c1da7a2fe40aa243f18ac8d4fca432475a90b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
