class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f06376ec4574a44fe5609ba65faf28c54602768aaa77cefb4d7bcfe681b73719"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1afb94f08a77b0f7116ee8a191b51ff28611e9af3add31535e0b56e908a209e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1afb94f08a77b0f7116ee8a191b51ff28611e9af3add31535e0b56e908a209e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1afb94f08a77b0f7116ee8a191b51ff28611e9af3add31535e0b56e908a209e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e4935f80635c060c068a49f52c4b864bc836943c8a785b1f92ee3b72bb9155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43f64f1f4d624ee2439ea47f1c4c12de7de62b5a9783646fb7a5c8f3d3024a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece50899c584432930d48ef376a6fb450bd9fad9df6ba46958d8b8f3ef8e4755"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
