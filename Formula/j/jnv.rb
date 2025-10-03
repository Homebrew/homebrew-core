class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "03223fb20a4c65c2610b94e6208b65098e6b3fe836d3deea75931a5c808f4869"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "301a2f7d8cff4b045b1adc4a5e091346c2fc85cb1b5a28931716c1a920914fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d010593930d640c55c9cded762f2d9a23c6534816028310402e2c18b044378a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "508dc84c0fcc40063082a8681fedb4ead1d56383cca7de053b390fa65a277cc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b887bdf455de2dfb8b374f860e06abdc56d8430c7a523dee87cf954435ee93b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be9601ae80ddd9929302253e12a3d19d76ac360980048eb2676f0e6f0dbde3e"
    sha256 cellar: :any_skip_relocation, ventura:       "be94800f41994fdc44b339bb2d1b80a9bf1a2843cee9c110a481c73bd3e4da87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe38e6d9dd71bba2602551e1f06ee4df69e3d0eb6172932f5a056378d8e7b5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e8a235bf0e09d2c6530ce0665575cfb9ab6a0de270d93d3e5fe40024e1cb21f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end
