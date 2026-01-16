class Cliam < Formula
  desc "Cloud agnostic IAM permissions enumerator"
  homepage "https://github.com/securisec/cliam"
  url "https://github.com/securisec/cliam/archive/refs/tags/2.2.0.tar.gz"
  sha256 "3fd407787b49645da3ac14960c751cd90acf1cfacec043c57bbf4d81be9b2d9e"
  license "GPL-3.0-or-later"
  head "https://github.com/securisec/cliam.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeafe136193d401e2cc34aa783643bebd6f72c54c77de32f17513f60ef4a5daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeafe136193d401e2cc34aa783643bebd6f72c54c77de32f17513f60ef4a5daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeafe136193d401e2cc34aa783643bebd6f72c54c77de32f17513f60ef4a5daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a76db72bbb9a4de727a83f21d7817f8346d35a6fa100726105564c2bffa74ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569e828a0d43a70e5053c8699ad828d821bf9717e9151f55fcb6b553102883fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce98c401d6e7ef0ac1d4b76268981cc1bc4dd1fc111b6ed98eb90bc5c782b0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/securisec/cliam/cli/version.BuildDate=#{time.iso8601}
      -X github.com/securisec/cliam/cli/version.GitCommit=
      -X github.com/securisec/cliam/cli/version.GitBranch=
      -X github.com/securisec/cliam/cli/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cliam", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/cliam aws utils sts-get-caller-identity " \
                          "--profile brewtest 2>&1", 1)
    assert_match "SharedCredsLoad: failed to load shared credentials file", output

    output = shell_output("#{bin}/cliam gcp rest enumerate", 1)
    assert_match "accessapproval", output

    assert_match version.to_s, shell_output("#{bin}/cliam version")
  end
end
