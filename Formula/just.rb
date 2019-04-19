class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.2.tar.gz"
  sha256 "7bcde022994eaa06ce17974f494e4cf98a1d00f4e5791c6ae61f8dd45685da25"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d43f3d4c61eb0cff35b2bd0f6c6094b1a9437dfab8df79ce7c5d096f97430f" => :mojave
    sha256 "715fb7af58659ce90e2a6a241f2d622df112488c334c88166bc2b2377b57d6fe" => :high_sierra
    sha256 "f0956c2e6e4ba10ba1bf3a1182d2641f6cba6091cc08c1d75b8023345dd6c419" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
