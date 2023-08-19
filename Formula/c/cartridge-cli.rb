class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.12.7",
      revision: "d6206606dd064b2602903da6209952b4ba693887"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "977588cf1140c6dc575c7890b366ff4bca674510510029dd7359b51dc4a30553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2045823a9b3c61b63af9a7ace9b6970bee34b0fbef8e1fa7237a53540884fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17393b58f85abeae905cd6072409c2ecc4782f3fa897e0a68126747fe69adcac"
    sha256 cellar: :any_skip_relocation, ventura:        "46d50e2d0199dceda164e6bfe175e6ff948041220c279b825a5e38a99fc0059f"
    sha256 cellar: :any_skip_relocation, monterey:       "cefb5e810a85c9748a31ad72d95392ebed97c4f44c720490c874407db6211dd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f39cc9402e4dfedd2f60b36eada68ec770818361981cf518f0d15f2a445d7c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14fb300f6f623c5e62c1de9afe55a9e6f481398edae5f6fe39fd824525e0c149"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    system "mage", "build"
    bin.install "cartridge"
    system bin/"cartridge", "gen", "completion"

    bash_completion.install "completion/bash/cartridge"
    zsh_completion.install "completion/zsh/_cartridge"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
