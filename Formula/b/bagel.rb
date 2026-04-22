class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e9303999c5a3e7af03d935f10737cde5680f74572843ed75eea3e9f8534bf2d5"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c1ba8bc9581da129554e65461522d8cfa4c683ec2908108f9c5c05d343bbb9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1ba8bc9581da129554e65461522d8cfa4c683ec2908108f9c5c05d343bbb9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c1ba8bc9581da129554e65461522d8cfa4c683ec2908108f9c5c05d343bbb9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f25b85b9d4d05d0c4f7793be9fff148fde903c55880108decbc738b50fd3dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e56f6a309dc858c1d4973a3e1e4d1fe3ebb2b1540649fdb30781a7ffea1ddc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9fa06a753cae53fa59aa45b324e070422530f72b3f0473f454c16e8b4fe8a53"
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
