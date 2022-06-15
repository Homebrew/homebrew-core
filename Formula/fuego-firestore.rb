class FuegoFirestore < Formula
  desc "Fuego is a command-line client for the firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.31.1.tar.gz"
  sha256 "4657ba2854a28d3cf58c0818c2088b650979cfd3cb5c1dd3be4669b88b1cd870"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
