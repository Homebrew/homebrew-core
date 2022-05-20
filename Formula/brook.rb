class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220515.tar.gz"
  sha256 "e054d0c3d0090b2015e9ff5e94a15b452a3e4e1de4588542972cc6c06965537b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfe93c2278c2a0c74bb0b0aeb8a82699517a418e581aef8b985722b2a3191609"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f7be30d7a9e822d347ab9fa79a7834436621d7b9c726edd638dcc44e287dc97"
    sha256 cellar: :any_skip_relocation, monterey:       "78e4093c1e9614fbc3c7394908d5a12186beb2f07d7cebe7b78f485ad10a07d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6284cbcf0042fe536c80dbad43974babd960f85a430357c8412d3603ab8d4dcc"
    sha256 cellar: :any_skip_relocation, catalina:       "6af40dcc6e4e939a374bbce88f29bacaf8cb3f7362e8d3f4bd7ef65b15b92f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0a544f4828f50fec0fe18b72e544c9be8e370fa27bb4a5743e3c86b852f285"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789&username="
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
    assert_equal "", query["username"]
  end
end
