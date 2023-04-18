class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.2.tar.gz"
  sha256 "abf751ccbd0a633466b7800bb66315c07172154cdee66307feedbdea3afceba3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249948328f21e2e35a64e6a920f6208d0f57b2a7d2ba7e370b59d0ff860000d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "249948328f21e2e35a64e6a920f6208d0f57b2a7d2ba7e370b59d0ff860000d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "249948328f21e2e35a64e6a920f6208d0f57b2a7d2ba7e370b59d0ff860000d6"
    sha256 cellar: :any_skip_relocation, ventura:        "89dff8f49ffb6c35bae45a335fc79204fbb7fb50a4af7e676a602f55d87430c6"
    sha256 cellar: :any_skip_relocation, monterey:       "89dff8f49ffb6c35bae45a335fc79204fbb7fb50a4af7e676a602f55d87430c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "89dff8f49ffb6c35bae45a335fc79204fbb7fb50a4af7e676a602f55d87430c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b0938037583ef3c9c8fd0d133854c76b0d26b9352d6a873882a2920f1e2828"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
