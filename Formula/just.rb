class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.8.tar.gz"
  sha256 "f0d3363f7e7604aeb355fe631421bccddb458756b5d951b25c071aa38d3e72a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "357266240ea70600c0d5c00a6888e31a64612b352f1e613180dff95b7ee93d69" => :catalina
    sha256 "af376e4550db79eb97c3bb91e285c2f0fdeae1f8f80ef2a9627183766e2bdb55" => :mojave
    sha256 "7cd62c90e0d81b96c16ad54ccd0fc1fb26327184a2f4618f2e59eb2285b306f9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
