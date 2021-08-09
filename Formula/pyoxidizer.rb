class Pyoxidizer < Formula
  desc "Modern Python application packaging and distribution tool"
  homepage "https://github.com/indygreg/PyOxidizer"
  url "https://github.com/indygreg/PyOxidizer/archive/refs/tags/pyoxidizer/0.17.tar.gz"
  sha256 "9117d411b610e29dfd8d9250cd1021afb545550fd7e698b623e913c26114f013"
  license "MPL-2.0"
  head "https://github.com/indygreg/PyOxidizer.git", branch: "main"

  depends_on "rust" => :build

  def install
    cd "pyoxidizer" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system bin/"pyoxidizer", "init-rust-project", "hello_world"
    cd "hello_world" do
      system bin/"pyoxidizer", "build"
    end
  end
end
