class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://brook.app/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20260101.tar.gz"
  sha256 "70e8310f31cef3b80e1696f364f12b2ab2aa0f1fb9fde00f25bda7620c21f096"
  license "GPL-3.0-only"
  head "https://github.com/txthinking/brook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc892393fb319b3573da8caf28e1a2083c052653375c1148af3cc40b482e30e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc892393fb319b3573da8caf28e1a2083c052653375c1148af3cc40b482e30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fc892393fb319b3573da8caf28e1a2083c052653375c1148af3cc40b482e30e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfeb21863c273b142f342a69ee50ed785bc6e738623dcc8a8d5ebba8edcce716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9ed2618dc37deddbd6030631cf0130859fe4c496b683377643bddd926af182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8008603eeef8439794732a85541831c398010f9794f2224fb4f8159629e9c9"
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
