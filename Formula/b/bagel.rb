class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "fe7d91c2887e32d638fb163975f099fedd32be11d533a00a91024332bd4de26f"
  license "GPL-3.0-or-later"
  head "https://github.com/boostsecurityio/bagel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22b44df0b60070e7b15fbbf00a5bc6aea08eed50cbf3c0cb03cfe8f799b8b53a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22b44df0b60070e7b15fbbf00a5bc6aea08eed50cbf3c0cb03cfe8f799b8b53a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22b44df0b60070e7b15fbbf00a5bc6aea08eed50cbf3c0cb03cfe8f799b8b53a"
    sha256 cellar: :any_skip_relocation, sonoma:        "767be387ffd0275451a0948a26082a9e59fd50a77549e7b4f01fc278125f26c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20621b1c3778d0488f9b9b3d255da9bf5bcf2b696ea7e46b9dead572d451b9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ddeefee9b398829ef5b4dca00b152e660ea20a819ffe917eb47f22a53ae099"
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
