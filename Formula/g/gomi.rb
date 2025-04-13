class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9cdf4ec51e6629573bcec7779e1b30e0bafbbe10d499cc2e7bbae46a6b3d3621"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e166d3365b2f193c300d421760676d8837c2401470bb8e71982e94dc5086b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59e166d3365b2f193c300d421760676d8837c2401470bb8e71982e94dc5086b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59e166d3365b2f193c300d421760676d8837c2401470bb8e71982e94dc5086b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b3fbf987e5e742a2b755d5c630d7a8405f9c4e231d1d86da28a5e879fdf19cb"
    sha256 cellar: :any_skip_relocation, ventura:       "0b3fbf987e5e742a2b755d5c630d7a8405f9c4e231d1d86da28a5e879fdf19cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70b33f949cd0384d6b53b469c340e642d7ce90317d130659026d7513be02df3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
