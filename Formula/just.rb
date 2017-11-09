class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.3.tar.gz"
  sha256 "32409c17efec182583562ff282b85713e8948ed218e7ce38f47a6ca443ab1b05"

  bottle do
    sha256 "7e1cb764ca34917d152c7ffa77fd9fc1220ed7c15816aceb160af91a76b2cf01" => :high_sierra
    sha256 "a1483e8a8aaae80070837e1a2edebd176f36c1c2e74ab317e7c2e5d8c6027a5d" => :sierra
    sha256 "4d6526000aa20a32569b8329607b22c50aca71d1ea6fb799a326547a38de50c9" => :el_capitan
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
