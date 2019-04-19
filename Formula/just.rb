class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.4.2.tar.gz"
  sha256 "7bcde022994eaa06ce17974f494e4cf98a1d00f4e5791c6ae61f8dd45685da25"

  bottle do
    sha256 "24bb1b62a58e031353ca5509ea3f0fb97de0f05a094e6a69f184a3bf78fd6c3c" => :mojave
    sha256 "6e64aea89c680ed2c470c3ab7047e2cbb5ac7721c64719b78e1a33de81fd50c3" => :high_sierra
    sha256 "d4f8aa39aec18902b328a81d03483c724dab02fffe2529c802f5cc6f7dc4a883" => :sierra
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
