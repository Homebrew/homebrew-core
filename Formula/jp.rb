class Jp < Formula
  desc "Dead simple terminal plots from JSON data"
  homepage "https://github.com/sgreben/jp"
  url "https://github.com/sgreben/jp/archive/1.1.12.tar.gz"
  sha256 "8c9cddf8b9d9bfae72be448218ca0e18d24e755d36c915842b12398fefdc7a64"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    build_root = buildpath/"src/github.com/sgreben/jp"
    build_root.install Dir["*"]
    cd build_root do
      system "make", "binaries/osx_x86_64/jp"
      bin.install "binaries/osx_x86_64/jp"
    end
  end

  test do
    pipe_output("#{bin}/jp -input csv -xy '[*][0,1]'", "0,0\n1,1\n", 0)
  end
end
