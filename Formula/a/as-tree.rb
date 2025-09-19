class AsTree < Formula
  desc "Print a list of paths as a tree of paths"
  homepage "https://github.com/jez/as-tree"
  url "https://github.com/jez/as-tree/archive/refs/tags/0.12.0.tar.gz"
  sha256 "2af03a2b200041ac5c7a20aa1cea0dcc21fb83ac9fe9a1cd63cb02adab299456"
  license "BlueOak-1.0.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "21036f05ea5294ef3b8f2fb17517631a76c8d2c2ed521311322a55ba2320a28e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5059a4f64cd775588b4f57a258964415373c09346d65f121f9e61464bbc6789a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c54dc2d8c4eb0848cf008d1aba865d566d31a711fcba898e06d50553f14e4720"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ff59d33ae1147f903973d50d44e945b7d4ef2564d8877be6fc38b9433bafb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ffe542490373f69918fbb37ef7e93c94a7d26e87f4be282b491816713b7d049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cbe38f0537c86b65808064608c61b8c792098177911f013f24c2470fd2fdf62"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a2de8891810abc35ac5c0815003aac603e9467633eaebe161a71e8ccc5dadd"
    sha256 cellar: :any_skip_relocation, ventura:        "427e9bc1f7f6a92da07ad4284e82ab6b3d24441bac2c0f5b4850c250106622b6"
    sha256 cellar: :any_skip_relocation, monterey:       "adf2bb6e9bbbcc4d393462ec04b4cf9abe28bc5748f9636b0a9668b56082fb60"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d13c83015f82b0b39760b9087f417bc1465b4e33cc6a90061235a70e510c896"
    sha256 cellar: :any_skip_relocation, catalina:       "5c14a2f148f036c39c7187f0da94f9c6ab52f3e9c531c5009ae5e6db68b01cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c877d85a4310115448ce71c13d75b93976ee2bea0b0ef0e890c53a469e8f85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82337903e0b8ee48cd19517b4d1bd8e0b66d5c17e212a03f6e15d2b12130d85b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal ".\n└── file\n", pipe_output(bin/"as-tree", "file", 0)
  end
end
