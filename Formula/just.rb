class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.6.tar.gz"
  sha256 "25b37ad9c44704a89a8ab570157c9c78da63c481aac75caa40757d9bc84a191a"

  bottle do
    sha256 "52f800707225d5847ab43967f4d0d50b6a1b96763bedee300829ea6fcc3b9eed" => :high_sierra
    sha256 "e1ad66bef5b0dabd2be8a2af72d129d3d6a2e81b5570a6b1a9a56f9f869246ce" => :sierra
    sha256 "959efe969763984c165acc69364cccd766d19d3ae087e304b648e926a34ef9fb" => :el_capitan
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
