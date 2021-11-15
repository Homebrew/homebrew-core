class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli.git",
      tag:      "2.10.0",
      revision: "2b87a1b1d6159d8fe8ed52bca58a00365e29cbde"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56bd1168aa1ee62c674d32226f15b0b92f7e90bc131420f70f8f5dd405f45466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4377b98d0ad6eb4505851335a1f0f28efaee3c08038e4e6b01e2b45a30746236"
    sha256 cellar: :any_skip_relocation, monterey:       "0df91da76c60a8e3b170411516c4d3fe051684dcf685454aa7054ea8814f079d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a7029c4c492dcb0dc25880ab262e8990494ac59839906459974d39f3c18a684"
    sha256 cellar: :any_skip_relocation, catalina:       "f6a520934a4deb9ced42ce061c5d5c3b8742afb25835fb01a6db0be84a3ce315"
    sha256 cellar: :any_skip_relocation, mojave:         "08fdfac9a58c68546ffc0c6333997bb5de778d9ac19406ec679173e197dbb4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50793e3b6cc34d7e8e1e9f3f815db7e26a8caa7b709f2fb939b6c683b9077506"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/tarantool/cartridge-cli/pull/618
  patch do
    url "https://github.com/tarantool/cartridge-cli/commit/84193babc1395208a205a0c06a4a8a9a73ab6512.patch?full_index=1"
    sha256 "5b50feeeb764018cd226595d733d6467b922a9974fc520c52c1ca692495f99c3"
  end

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
