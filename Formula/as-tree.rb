class AsTree < Formula
  desc "Print a list of paths as a tree of paths 🌳"
  homepage "https://github.com/jez/as-tree"
  url "https://github.com/jez/as-tree/archive/0.12.0.tar.gz"
  sha256 "2af03a2b200041ac5c7a20aa1cea0dcc21fb83ac9fe9a1cd63cb02adab299456"
  license "BlueOak-1.0.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal ".\n└── file\n", pipe_output("#{bin}/as-tree", "file")
  end
end
