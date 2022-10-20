class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20221010.tar.gz"
  sha256 "987b2ddac349e5ac2b91b40b06f7686dcf316c37bfe82c566fdc7503f0b4d97d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1ccd8ba7b709bc3d08904b1d37983373c6920c88cb1397cf89695a178b5a7a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f8463aa49bce1c06dd1a21fb7fbd52a50531dd17ed2b3c5967e7e3f7180a13"
    sha256 cellar: :any_skip_relocation, monterey:       "e999661be04d4adc633889e08e3fe332b4bb6de2df75f99bc1fa3ec5f0abeea5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aa340025ec2425751c0ea734f92eedb97fecdca156eed9367ef18acab3aff6f"
    sha256 cellar: :any_skip_relocation, catalina:       "2ca662ea86e5225bcee96a77f552b19a7954b52d7d35d4d6129137fe2885689e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b442b0ae1f8cad15adda076c1eeffbacee511daf3982b95b7dabb5598577e86b"
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
