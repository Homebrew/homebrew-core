class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.5.tar.gz"
  sha256 "1cbb897927d590fd7aeda123ff18958a99ba6389d32870605d1de991cfddd705"

  bottle do
    sha256 "62b828fd3295c2978d26f321c0b16eaaf795e8d5cd92cabd2a49ff04289a60ec" => :high_sierra
    sha256 "ab13445c92586431895e54c6ff18976c8668ee7c0ee8aa03bbc1b91ef7e29872" => :sierra
    sha256 "d958f3da28c50164960a197b0e7fe06108a8580a5fbe1e6f76d89cc4697a9374" => :el_capitan
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
