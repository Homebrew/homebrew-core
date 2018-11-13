class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.13.tar.gz"
  sha256 "802241f8ab0b5f12ec84bf736c165fb1f81a108675223eddbea21834169a05e7"

  bottle do
    sha256 "b47d8d2d3702f5d98e5537f393893594818bdaceb4e42ef093e55ddf530c098e" => :mojave
    sha256 "a3cf6e47a38bd3cbf8bfb09dce648f447dffec708eed07994491b1509bf857a8" => :high_sierra
    sha256 "b1e19274a73e5bf4d0b3b38bd26270d9b4ff97e4191ffd3ecdee353e0dae468e" => :sierra
    sha256 "a46cd86aa51e106d8025ab98cc560b3c1adee3524a7121d81ce63ae274403573" => :el_capitan
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
