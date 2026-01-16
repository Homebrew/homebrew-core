class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "512004c1e8f5fb0984d71457f761c2c4defd3557684988bc64ef3fdb51348f34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1ed4d3dfac6321320c5279fff6d051ece10afc25fd43e73593fdeb3a7cefca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9804ec1ae9f4df733066a1045390bc9b6795dade4921ba6563ffcdcd2698321a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d1664a5bb289fd4d0e60659100c32cb356aeb66e8630a91d76deaae151da21"
    sha256 cellar: :any_skip_relocation, sonoma:        "44c70ba5d7b4c89f25c504d3acedf16e821a9c615ba3a47bf4da0351bcbc8dcc"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end
