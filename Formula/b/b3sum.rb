class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.4.tar.gz"
  sha256 "b5ee5f5c5e025eb2733ae3af8d4c0e53bb66dff35095decfd377f1083e8ac9be"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4100532594b5001bbcd160336763bc4c8e826de7f2167a55ca8039e49bbc81d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9796e711df22877d8220ffdec8f1f5df498b31f7379426e651f66eff1c1537c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a6043328002eddbf20b66caf2ce882dd20edb74d2366e5239d57c274b9a2da"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec11d828f1564a78d0b5771de10c5794cfb3816e4e44e83a6056e0bb531e1274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573c3fa1546591b01ea7767c27b87ad8441ac709e01114f19cf2e14c0f12da8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2585317d48c21de02b4505fb63e56921aa571b6b9f64f05cb79ad72ebe6ea032"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end
