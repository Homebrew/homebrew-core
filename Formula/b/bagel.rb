class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "08ba311938a567f582d9ee075645d333e1d315e09af706aeaf5efc0af8b888e5"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11d59fc62ceb292573b7697f19ef46e10f8ec195f8c4af312d18ae67b2d68709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d59fc62ceb292573b7697f19ef46e10f8ec195f8c4af312d18ae67b2d68709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d59fc62ceb292573b7697f19ef46e10f8ec195f8c4af312d18ae67b2d68709"
    sha256 cellar: :any_skip_relocation, sonoma:        "562cbba57f84b9154b0e826285ae40e7a9c19708c88f5ebbb65946d056cf9ff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13876d13a0037e92289869c269586a0f20bb7fd6c3612b4093e4085565947238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38c36a43b143646f10e408223b3fd05477afa35cf48595d0a6a3a3c803b75c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/bagel"

    generate_completions_from_executable(bin/"bagel", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bagel version")

    (testpath/"bagel.yaml").write <<~YAML
      version: 1
      file_index:
        base_dirs: ["#{testpath}"]
    YAML

    (testpath/".aws").mkpath
    (testpath/".aws/credentials").write <<~INI
      [default]
      aws_access_key_id = AKIAIOSFODNN7EXAMPLE
      aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    INI

    # Removed the explicit '0' to satisfy brew audit
    output = shell_output("#{bin}/bagel scan --config #{testpath}/bagel.yaml")
    assert_match "AWS", output
  end
end
