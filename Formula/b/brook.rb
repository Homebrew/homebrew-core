class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20240606.tar.gz"
  sha256 "eee1c6173daff3199c23396f4661d7f81d701dc0f4eb1662b39041a6ca10703b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e27f59a4f201674dbb3f223071dd3831a55a7d508b648233c9de589233bcdcf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f8696bc8761837bd720b1c34d185b5d397dd8d360805930d5f11d3fa7cfaae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b06bbda1bb1212e26ab344b08d98311d365664aa525b72d963884beef277638b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8272da2d9290f361d98112c5440f72a66387dd27ffa698124e94e02a44498350"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc3b0cea971ec18be11578695dd78be08c5e545010c79c1819dd7de072eebd18"
    sha256 cellar: :any_skip_relocation, ventura:        "93100caa735ee10b6cc3b78baa1ec2cafe6080f0aadc6dd44fbdae38008ee559"
    sha256 cellar: :any_skip_relocation, monterey:       "b56112d70bfaf73ba67005ec70c7b1906f9b3e65264282d0c93ae5f47311dd66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0895da94f720389a6e90166d1661cbb162e63aa110900c2f56f764451c38181"
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
