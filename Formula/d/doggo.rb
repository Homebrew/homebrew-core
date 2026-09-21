class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e0d043aa34fb8daa44df07558fd32fe2686eba6644d5f6834edbc8a789d42e1d"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16085eefe08996902b25aada942d31114491aa55020a41128f6eeba6cc19c522"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e805f38eb20b5ca3fe542b6514c41d0565116973718b592bf8f07673707fc130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e805f38eb20b5ca3fe542b6514c41d0565116973718b592bf8f07673707fc130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e805f38eb20b5ca3fe542b6514c41d0565116973718b592bf8f07673707fc130"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "634f72e44332cf18023aeaccabf6b104eb3166c8c71fce16557a1ca5cca9e74e"
    sha256 cellar: :any,                 x86_64_linux:      "174fd0f70d500a3aa1788391c3773beef6fac920ec8f4b878247d1723436c33c"
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
