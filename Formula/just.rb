class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.5.10.tar.gz"
  sha256 "ae8219cecad107c296e41b486e1966f0c19ae3222fb29d3738aeaa3c34e4a431"

  bottle do
    cellar :any_skip_relocation
    sha256 "67dd7b8e9a9137a6a1f3eeb5710fc694e8db04aa94c1d48ac2639c01908ee8e6" => :catalina
    sha256 "5454dd9ad4c7f6c0bfec0f961f3173f6b0feb9c414b59938c74d4adbb030c5be" => :mojave
    sha256 "88c91e40c20705baf8479a9d915b299d16f1e95a517f6a9f568edb93a9425391" => :high_sierra
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
