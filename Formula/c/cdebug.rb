class Cdebug < Formula
  desc "Swiss army knife of container debugging"
  homepage "https://github.com/iximiuz/cdebug"
  url "https://github.com/iximiuz/cdebug/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "9bc1779fb342029e2e7b53ac4708ac939d2d55914974752cd64b040617c3b496"
  license "Apache-2.0"
  head "https://github.com/iximiuz/cdebug.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3158b41fb2723b2e09dd4884a9e1e0f280605186931172698a79a46f50cfda55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3158b41fb2723b2e09dd4884a9e1e0f280605186931172698a79a46f50cfda55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3158b41fb2723b2e09dd4884a9e1e0f280605186931172698a79a46f50cfda55"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee4f9edd17c35e45fea36dcf2edf4d474735f7559c0672c9bc1d14dfd4899d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "532e056ac9f22ea053a51933090499cd8a7f44cf932b4afc64586a1b00187e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b639915beeb487a44676e86342557a21649566247b01c4d294b24cefdf9671a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cdebug", shell_parameter_format: :cobra)
  end

  test do
    # need docker daemon during runtime
    expected = if OS.mac?
      "cdebug: Cannot connect to the Docker daemon"
    else
      "cdebug: Permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/cdebug exec nginx 2>&1", 1)

    assert_match "cdebug version #{version}", shell_output("#{bin}/cdebug --version")
  end
end
