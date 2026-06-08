class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "1b7509fcbc27b571cd52359799d3e7bddce020b5088304d3ff9c0911a65dd78e"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00625613841aa03409338310aa165abb7095567306bde7ecdc84fb01a3398160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00625613841aa03409338310aa165abb7095567306bde7ecdc84fb01a3398160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00625613841aa03409338310aa165abb7095567306bde7ecdc84fb01a3398160"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9dd414cf01c1034ec85d59b74cc45b9b2cdbd9248ca12b590d02c06c89dc46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3110ebbac1c27777caebcbfbe112af5c615734ffec336d0d0842941c9ad5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a357cfbecc49a951a197d3b3b0af874eacb91b55fe357ccc4e5f2c2ed1a5385"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # UI build
    system "make", "web-build"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end
