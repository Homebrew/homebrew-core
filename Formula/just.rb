class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.3.tar.gz"
  sha256 "32409c17efec182583562ff282b85713e8948ed218e7ce38f47a6ca443ab1b05"

  bottle do
    sha256 "361597da1ad5ef750467ce377e8a31de483bae49fcc856b628ec9d396c297442" => :high_sierra
    sha256 "ee37a3a4ff27c1f5e789c0e349738790db9ec6b99eb6f2b7b584451f7982a167" => :sierra
    sha256 "e8d7cb56805d2c19a69ad463343e2f9ec70d0568b36d568116ae86e264d8a9c4" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
