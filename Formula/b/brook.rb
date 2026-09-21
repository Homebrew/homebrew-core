class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://brook.app/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20270101.tar.gz"
  sha256 "43d8e5476918daa2d35fc63e8b0c94c0c1df8577f1d09103a3ab0f6141f29c0f"
  license "GPL-3.0-only"
  head "https://github.com/txthinking/brook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6c88e6f0715a4ce9eaa99e903a4798af55677be3e20b98817661ef7691d6c1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6c88e6f0715a4ce9eaa99e903a4798af55677be3e20b98817661ef7691d6c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6c88e6f0715a4ce9eaa99e903a4798af55677be3e20b98817661ef7691d6c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "362fe24d762548d06ac4e448965040f431ab60802cc8561e0b8d5ab8bc30e201"
    sha256 cellar: :any,                 x86_64_linux:      "6299bd5ea11349e0cf0f09dc979a529ce1b1baf193c191714a1d4a7a83f2ac34"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cli/brook"
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
