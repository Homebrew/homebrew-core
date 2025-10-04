class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "387588e6eb8927920e45acd4121c90756ad69c6d16f5b7f94f2ceaaac45d3a73"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ee0b23e669161779233848fad860521187151f1c7cc154f56bc0229d88881d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "185ca71d955334d14dcc9d9c9dee9379e9762909a81c08e7912f8dbd5310739b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05b69f934216a147aa93b92dcaf72e9f38f806fbe1c87f044b9c999622315c97"
    sha256 cellar: :any_skip_relocation, sonoma:        "642fb42ccac217d020faa57a26f9663cafc66a15499beda50424964796caf596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac30ac5c95bfd0117a63e520e127c0e899a9500f71a18112871988daf4227659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38df280421a9f00b883f113882555ab11e4707dee3d997c7c463f3f40095317a"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
