class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "9c5d1d0d800f72e80d35f6731fa3a80435f5a1af08af900a6b77142600e19395"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dae82f090bc5602ac931bcd42e2e5b03316d83067124fc8b6214b78caee00d19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dae82f090bc5602ac931bcd42e2e5b03316d83067124fc8b6214b78caee00d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dae82f090bc5602ac931bcd42e2e5b03316d83067124fc8b6214b78caee00d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2dd0006d0639aee6597c36d144e256d1760cb47f8a30430117e599dc849f0cb3"
    sha256 cellar: :any,                 x86_64_linux:      "cb52ddb5b5db603f6e7fae7c554d89861e9d2a0c40279a5d15eccf928aafa24c"
  end

  depends_on "go" => :build

  # `test do` block performs DNS lookups
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
