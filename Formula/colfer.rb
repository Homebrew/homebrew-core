class Colfer < Formula
  desc "Schema compiler for binary data exchange"
  homepage "https://github.com/pascaldekloe/colfer"
  url "https://github.com/pascaldekloe/colfer/archive/v1.8.1.tar.gz"
  sha256 "5d184c8a311543f26c957fff6cad3908b9b0a4d31e454bb7f254b300d004dca7"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ee59a49a4e15f40a620d526039cb8ef82e5c323f59f6df3074f1aa153c3fea4" => :big_sur
    sha256 "e909fd6305c6b00a1499756f250666ccb80a285b2cd1115aa95edb6e31593ea7" => :arm64_big_sur
    sha256 "dfdb2743960de62ee18ab35a7ead3d2d8de4207cc6ffa11ff0d8ebf393a591e8" => :catalina
    sha256 "dfdb2743960de62ee18ab35a7ead3d2d8de4207cc6ffa11ff0d8ebf393a591e8" => :mojave
    sha256 "dfdb2743960de62ee18ab35a7ead3d2d8de4207cc6ffa11ff0d8ebf393a591e8" => :high_sierra
  end

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
