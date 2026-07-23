class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "ef132916c520489c786bb686c98df3324f6ee621587564d3fa53a82af54698a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afc8a44e05a2d1c40860815d514f6e2d15d809ff7fd462174307a251986ab68b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5688fb89f9a1213fe0f5f66543e4dc096d10f75a8df6f90ef88cb0d6998724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a1f7b6f01cbf71280c05b8bc2bb0754f3bc8b255b0632d5cb79bd63f9542de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "768da087db8df3ccc3171292455e55d7d546f2bc7a5e4a4922a6f787af78607e"
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
