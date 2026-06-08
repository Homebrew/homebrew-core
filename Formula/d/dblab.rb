class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "1ca764d6de9fdf3dc919ebbc55811ad46752dd8ba187a4343232ca7ddae6b333"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8811c4d36628f4e0c147bcccee8c706229c870e6160710581a1746cb9a165246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477c4bf42db73832332eddde3c8998be1f8bf3ee3dde273c56a7f03d488cb0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140c74f43676814becdb1d90ec260ba5e576f9c3bf2bd78601ee8a284a3de50c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f132951c993d1f2d944901c7bac0ae21e2f4cf5fbdbe261866343c4e110a191c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4395532029702673820fca3e48f8ada0e61ce717752cd2b08c2d226690adbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ed84a86b8d5926e97973196b5159bf541f14878233713f831b160ac2b6dfd1"
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
