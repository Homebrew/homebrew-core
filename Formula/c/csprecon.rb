class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "75a8504b0c0e22c571b7caeb62740438aa121934a83b5bcb8eb554c3e8e696d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9866d9e878c791d3dc770739f942a9529c99c3f377cb30e1e326ebc3465d84bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a2938a862f59323f78184471abc0402474562b280402f3c8da3d4dd9e0ac01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae62e40458e3794d884a19b86e7ac2ac7880399681f0728ac703eed53083e4ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "adba9c1619e000b1ac6f8b293724be3fb2a08d6bea88076627bcc27b5e6d448d"
    sha256 cellar: :any_skip_relocation, ventura:        "3713eb26183be2c5fc8438ceccab3abe455d12a9b73f39876d02a45386fa7f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "516f2cb87c41ad7320d3c2f48b977a7616b957e66fd765d5083dcd01308c8b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2235d85ba6ffcec84b25d1af1bb1a4111cc3654106b9c13ae4ee72346ae037ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
