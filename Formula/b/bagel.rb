class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "433391790aaf22713a8053d39f6f2fccd39271b49c2d38ddae60e994f075c86f"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "841ffe55df30c526962d2f2b8adfdd252ea5c935ceb0fd380e996719ae50b594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841ffe55df30c526962d2f2b8adfdd252ea5c935ceb0fd380e996719ae50b594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841ffe55df30c526962d2f2b8adfdd252ea5c935ceb0fd380e996719ae50b594"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a696bcf53d46ff6d1c623239e99898c5ab69c6499f0605f3b65c3eaaaac9629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64cda4ddb8ff0c8f252396bbc99493484bce4969e1452a857f0d1ba68288bce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7800ac0f554734185e08e699c54fa3f41bab16742d64d3bbf67aa6f1591e714a"
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
