class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.5.tar.gz"
  sha256 "a444b7a28ad33c19113cbb76d6678ea966a64eebd366bc889fa83aa8a44abd65"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3933bb34c7fc20b3933ffe0f9fe7c3727866c8476f48ce4cfc62f44f1fff6fb" => :catalina
    sha256 "501d83b4a2d6d5e24f1429320909aca6c05787884a6ad690c55d9e6eb719d957" => :mojave
    sha256 "7df7779bd57aa0c48e7f97e0d617a76591e88dc6d5363b57c187f96f1ac594ab" => :high_sierra
    sha256 "23f3ddf400ef6ce95436539da360e21e3c89a373ad731cfb15a16ff8c5f3b82a" => :sierra
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
