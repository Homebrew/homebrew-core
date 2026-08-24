class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "6efe167744fafaa12bda5e910d256aff834068e7bd46ef931f19391c6765f45c"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a130f8371a8daea38b74b256c4359831d1aba09436f2e8893f020e4b492ba31f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a130f8371a8daea38b74b256c4359831d1aba09436f2e8893f020e4b492ba31f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a130f8371a8daea38b74b256c4359831d1aba09436f2e8893f020e4b492ba31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa359e10264106f7aed99e67e9486c5c778dcea4555e797b9c81bd085751a31a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94160069c4e2244dd46fa8ab22697e53c70680eb63a0c236840b11ef7dd42d9a"
    sha256 cellar: :any,                 x86_64_linux:  "713691d15780c86db0b1b680890cf80ab1622342be02c44e8e7dfd3cd6b01ed9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
