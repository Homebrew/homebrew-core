class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "305a569adf08eca238540a5ec10752082c70e702b11453c74ed0cd496b838605"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6837b7860086c488b87c631a1375f816d78d20041741c2318c5065ede054e354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6837b7860086c488b87c631a1375f816d78d20041741c2318c5065ede054e354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6837b7860086c488b87c631a1375f816d78d20041741c2318c5065ede054e354"
    sha256 cellar: :any_skip_relocation, sonoma:        "8884f32f9a66df9e6eca62b62387203b044176c67434d6bb6f58e39926d15eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6010f2f8c4ebfcd7639142abc79aeccd4f2d9e1128acbc6227086e0357437669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b7709fe465e0805bc7b7076c2b878ce36f7776d63e8115c75684d5f3018080"
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
