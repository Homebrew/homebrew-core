class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.11.tar.gz"
  sha256 "2ded5cbb140955e87e0edee5c9728146316a34fa0a23a4de1f7a28df569b25d0"

  bottle do
    sha256 "a250bafb3b21f931cf075f354f8ed77ff90f7f5be9188f14ad4c44b882a908c5" => :high_sierra
    sha256 "540606e67eedc2c95d19133a613fa40152e8ca0b693dc764c9b3c491a5564d71" => :sierra
    sha256 "4d2980f96306ec681a1de6c99864a632b72014b5d0c3971308ad6b5ea4baafe4" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
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
