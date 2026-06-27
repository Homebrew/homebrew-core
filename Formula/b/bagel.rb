class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "2707877746844c2c769e817eb64f5d3b3c696f723fec927284e93451236882af"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cf715981bf87fdb4aef2cdd6eb4af837f3338607aa1ffacc0676caa59fc27bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cf715981bf87fdb4aef2cdd6eb4af837f3338607aa1ffacc0676caa59fc27bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf715981bf87fdb4aef2cdd6eb4af837f3338607aa1ffacc0676caa59fc27bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "51f18c4663f5db81ae945b5c3fa8a656de8ddaf77007965d1052a37a8583b361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e37d48d76657f3789b37ca3d3d996680f6efd53e55856bbd7d36a880f895b9e"
    sha256 cellar: :any,                 x86_64_linux:  "b6ee520ff010322d113ad92fb6dd41bab9cdb0aa683864732f04895495322490"
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
