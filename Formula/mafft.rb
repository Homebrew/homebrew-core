class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.475-with-extensions-src.tgz"
  sha256 "bb6973ae089ea18cfbd3861a5b9d2c8b7e1543a1fdc78ac2d7cd8dbe3443f319"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cce002802d3d258caceaa2a20ecbdef0a75d14344f2aa7aa89aff5313a079c3e" => :big_sur
    sha256 "73d173849a883c98a41b7fd0820dbca549a13668e84c7e3e9f046cd5eec0c877" => :arm64_big_sur
    sha256 "798be41afbf9531ec0589c935a43e910cca42d66b25eb931d914324a1bfb1ea4" => :catalina
    sha256 "5f791516aeaff07e97ebd9966d7321f13436f99a6a232618e2ee2aface522377" => :mojave
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
