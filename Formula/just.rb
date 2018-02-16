class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.8.tar.gz"
  sha256 "fe14f07c90249f7e9e652f2baba337670dbfe18b73fccddc82674ee01af98d4e"

  bottle do
    sha256 "e860377d091e43e3f186033927269b63f8b60350707df836906aee35b022b17e" => :high_sierra
    sha256 "592dc264989af2c10ee6819e1c1096e71a16999e105c00932ffdd2a79313c1f8" => :sierra
    sha256 "ccd30aa9638bd34f8a0e9263e0c5ecd6ee7dca7da79f396cf7aaf1f19f33e155" => :el_capitan
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
