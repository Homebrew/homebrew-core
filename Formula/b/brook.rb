class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://brook.app/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20250202.tar.gz"
  sha256 "2ee6bf43345b2cbf883eeaa8350da161352610e4fee82c29b0d3411a3e761f1f"
  license "GPL-3.0-only"
  head "https://github.com/txthinking/brook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04547e268b88935b2c6101b9324126819adb599e795cabaa740e5fb04325c17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04547e268b88935b2c6101b9324126819adb599e795cabaa740e5fb04325c17f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04547e268b88935b2c6101b9324126819adb599e795cabaa740e5fb04325c17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a05d9d3eada57f63ca111712d411068bb691fd17ac588cf7444b26f386fa58d"
    sha256 cellar: :any_skip_relocation, ventura:       "0a05d9d3eada57f63ca111712d411068bb691fd17ac588cf7444b26f386fa58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3686e17eb912d009421511ea22337970205595adc821891ffdee034d8d97642e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789"
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
  end
end
