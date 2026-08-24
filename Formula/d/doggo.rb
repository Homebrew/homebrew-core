class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "877f047fe81185d4fbeec870d54233f7ebf7c707a41cb98d023c34e089f9a0c0"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b85aaee2e993de9cd31f5ff8d4f1d779529904f6415f39b0e948964a1756e216"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85aaee2e993de9cd31f5ff8d4f1d779529904f6415f39b0e948964a1756e216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b85aaee2e993de9cd31f5ff8d4f1d779529904f6415f39b0e948964a1756e216"
    sha256 cellar: :any_skip_relocation, sonoma:        "1af29050c243ef3b023af14043e534f384cfacc7583df4376d3d07f2d703d696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5042c3e3fbd93176240f94b648a4e7819cb1f6058c949eb87e2439856e0e04d4"
    sha256 cellar: :any,                 x86_64_linux:  "ef262c3e984ff4c920f09946ebef0934d455cb4219028d7bce2dc16ddc195ec7"
  end

  depends_on "go" => :build

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
