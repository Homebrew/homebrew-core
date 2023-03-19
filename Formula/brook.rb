class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20230401.tar.gz"
  sha256 "332069845b9c205070c0edbddc9e0204187499b97d4d1bda593535d775f556a3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e54be1bd9a232ae4f9f117770d539501dd720c3c4aae371d852d28c32d9f5bad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b521e82614aa0cf2153c1ac6daeed3bd849dcc52bc2cc1a02322a28e38d638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5262fd116b1f68889ea6f4368cf1a0be0ba8cfb54aa63e2d329fdd852462faff"
    sha256 cellar: :any_skip_relocation, ventura:        "57e0ac84b2ed6b10702b5470e9813d9d5bb212ddfad3b4ebd4ce5011374e4a05"
    sha256 cellar: :any_skip_relocation, monterey:       "b04ecbcfff7240bcc97e4e077231a7a1a0bb1f81818d9a5cc5fa1ea169129c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "67c3ea93fe1f470708e7d16f0cc19bb4a4ebe95db11bdb1a1d9ee7bfd12bbe08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96aa2d57b234ba30cf39c4ff022b5f1d4f5f3ee0d059eddb8c4afbdebbcbc429"
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
