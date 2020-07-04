class Colfer < Formula
  desc "Schema compiler for binary data exchange"
  homepage "https://github.com/pascaldekloe/colfer"
  url "https://github.com/pascaldekloe/colfer/archive/v1.8.1.tar.gz"
  sha256 "5d184c8a311543f26c957fff6cad3908b9b0a4d31e454bb7f254b300d004dca7"
  license "CC0-1.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"colf", "./cmd/colf"
  end

  test do
    (testpath/"try.colf").write <<~EOS
      // Package try is an integration test.
      package try

      // O is an arbitrary data structure.
      type O struct {
        S text
      }
    EOS
    system bin/"colf", "C", testpath/"try.colf"
    system ENV.cc, "-c", "Colfer.c"
  end
end
