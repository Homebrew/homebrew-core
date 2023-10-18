class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "6402f06614f2761062c7f1b6972e00677f7bd94bd0e9decc901786768ba9c72e"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ed41ba2f71607f1888dc660dfa5dc4643a9c2c8695a9e4af115a7857a32a18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d44b89e2e12c3cff50212ba09a9068ca90005c8306abbb8ef0ab969ba71e76e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83212de152508e09c03ae14fd7c5f04f1273702d9588dfe454640f7eafb7caf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55427f13df37bb6699013b9e1772bc604ddecf520aa4a49ed63880d7d1916c0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0782c94afee4b234d01b86aea38a432699274e06fa622dc6dd3bce8e0f1902cc"
    sha256 cellar: :any_skip_relocation, ventura:        "a2b7bfd8895bcbea45d35546d3f9444c42d5f101d1805133705182b9159f0e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "d78575a5478ba20a7afdbfc261d77c3d3cf0b968e25229769e1c2ba2acf3729a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18098e32463439796b4ef499973db4ffba36a0e8778efb0b8fc349b7c7c64d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2ba852a61ddc0bad33e2d7db77bfefd230d738db36c13d79dc1ebf289c4fd4"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_predicate testpath/"ca.crt", :exist?
    assert_predicate testpath/"client.crt", :exist?

    assert_match version.to_s, shell_output(bin/"falcoctl version")
  end
end
