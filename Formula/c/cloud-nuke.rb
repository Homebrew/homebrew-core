class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "cc3176e7736218fed14e28e23e4e9b673f3847bb433f72ef503b2b93f45f6e0b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c09fd5f225a98fe4daa57f7ce8d4fddf420f7ea3eb2a79f4dd3c2120a804ce47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba6d24d30b502432d61e69742efa9117451bb52926580c0afc1bfdbb98ef1987"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf02246ecc5849b5717d8525dfa42aff5b4041c1490f7195f65c54f2d79cf2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e231361452873e3eb0edca19ba4ef11bff4cbd541ea9d81adc06a8206afb8182"
    sha256 cellar: :any_skip_relocation, ventura:        "03c0c8ebb6d4afd616b48e95068066b50467da1ec7ddbd1fb14e5a3a16115269"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d610c935511b76804d34cda6bf9a3780dcccb37673062463634122ae1153c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a67e394aa7987b27ffbfa39482407b4e22ad9a7750f7dede6b8e8023648a44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
