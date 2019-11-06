class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.2.tar.gz"
  sha256 "0805e2e663a3d9702e80d12b5e9b54bafbecace08604cbd05e2121da30aaca17"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a58a9b54d4c3166f6b318464990196ba995430d3a225e6a322861b195c70fccc" => :catalina
    sha256 "b3379c1f00e90881fb0e5d4f684cd62208065e0339f13d810480a2d4c7f45455" => :mojave
    sha256 "2bde2644eb0412fb14bc974926756e8cc5da2b7e9eec55af8a16dbae5a5ef9bc" => :high_sierra
    sha256 "c0ad60bf13a602161c77c1d1140ffc22c8c08680fc7ec3d47914b0f8159c5b93" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/mattn/jvgrep"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jvgrep"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
