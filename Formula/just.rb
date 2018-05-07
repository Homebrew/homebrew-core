class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.11.tar.gz"
  sha256 "2ded5cbb140955e87e0edee5c9728146316a34fa0a23a4de1f7a28df569b25d0"

  bottle do
    sha256 "dad62ae38d82394db7ff411217adc5bc356112ce8e0d688389884ce3841f5dcd" => :high_sierra
    sha256 "d0ad5ed53d328ca6ce27668c3d49bd70c4dd964b9c97a5c27fef6f90e4d36ba6" => :sierra
    sha256 "4b2ae72a3d10c74f1b8c60cd4d13438dfc3a340740ff32fb07db21bf2f3f3edb" => :el_capitan
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
