class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.10.tar.gz"
  sha256 "b1b73609799883500bf57060ef48d056cc191662d67e18b300bbcc6e644d1529"

  bottle do
    sha256 "fe408f1f5036ae750a85d85327d4b2e6d992600e9cb740a1582ec72ec6d75ceb" => :high_sierra
    sha256 "5764ae2db72fe6b3581980392b7be78d26ff04f088ef81c3706ab5253ee56e95" => :sierra
    sha256 "15536a15bbe6ae27afb6525b9d5db1f0f9b066cc0ccbc92c4046187ff76bebff" => :el_capitan
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
