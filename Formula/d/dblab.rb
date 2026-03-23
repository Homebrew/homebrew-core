class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "3a59b429b3f221792106d4b42c9002c5fcc988585077febceaf2b93fa7a62cf0"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "108f7b52ad69e4d007407f3170bd09e059cb5857655e6176c8dfc48da29c34ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cfb07cb079450157d7ad8df29c78c5405ca10caa0a3d423a109a46520fcd376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de328fd894beb6fbb2fd3d3d697a5625b290cf7579f16c6d00a475502e62e9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d80286dec36e5b74ed2817dee75bf8def19dbd10d67336521b3997ebbd9fbe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab7219327d0b46342951a4c6e99a10d5b50694765bdc49f3ccf06889ad85444b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd18728cfc149dd54dc19d508bb8877be782125b0f0eae28a3026ff2672c6fbb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
