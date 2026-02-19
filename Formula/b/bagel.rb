class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7317200cfc6d7556c6c1fbeb244c8397f68fc2998348bf07dbdc4f9bed46506"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a17f0bae9a8f11892b079f7228d5d88ce8295de88a43a837359d8b7dca7de0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a17f0bae9a8f11892b079f7228d5d88ce8295de88a43a837359d8b7dca7de0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a17f0bae9a8f11892b079f7228d5d88ce8295de88a43a837359d8b7dca7de0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda06f15cd570be2c5c99a1f024079e0b79cfcff85776583c2c5814cf4df05ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e952743eb402d655bcff252726cb44eeef96512616d959cd75527f46317c325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa67a3f863484b1d32fcd713843a7f8710509b1485e5e754f6413d98fef1d372"
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
