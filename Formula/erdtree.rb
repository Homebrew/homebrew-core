class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "bdabaf2c24c560be2cfd4a980996c885d960309813685bbfdd35be188af3bd39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06eeb5f63421e89b2fb3903f6358c57f16c11d20fa8f4ae4145067c705dfdd8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fa69fa1e199114d4a74747caf2326ca3f2a7fa835b16dfbfd3bb7056e64e060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3a7adce45b2b93286908fa0d00bda71025250cfb0828c75b58c72375d59ba24"
    sha256 cellar: :any_skip_relocation, ventura:        "6cc957e9d4184f257443c6db2b9cf3b218e38b08886c36e000795478cd4148e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e11fc2c581631d039cb701165a288e0922194cfe0c96c7402902a004154c3469"
    sha256 cellar: :any_skip_relocation, big_sur:        "48f8fc5a5107e41b8bb44139f39ec72efd6c52f5388722854c2d88339197fc0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00b5c6773f942e0ebe74cd774c786a5fb0b8aaf592950235ba9026f5d57e2cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
