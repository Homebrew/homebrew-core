class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "f0a67f9d66b8740151eacc9fa31fb47786554e4bd365f88e229d2fe38d45d462"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    manifest_sha256 "47cd72726b9856bbeaa1d3d6a80988df1740dd8c1bf2e1ada864c77143e80f15"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfd8939a2d90e7dd4793b589b247b3a50e45cda48894d166f22ec9814b0108c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfd8939a2d90e7dd4793b589b247b3a50e45cda48894d166f22ec9814b0108c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfd8939a2d90e7dd4793b589b247b3a50e45cda48894d166f22ec9814b0108c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39bdd814ad13a7b07b76e6db5cfb1ac5d30f1b8b5480385af49c3ec3b58f3aa7"
    sha256 cellar: :any,                 x86_64_linux:      "bfbadba4fa81886bf74409ed7d77ad8f3579c4cb6a50f866ca84f4dcb2139c1f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

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
