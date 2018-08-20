class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.5.0.tar.gz"
  sha256 "ae96e7397ece312fa4e074a340fc9438b4b3f69d541623db5cfd5749b2baa3b2"

  bottle do
    sha256 "63e53f441035fae3c6e43e967e93813e35246071e30ec03f68bb9682498caecc" => :mojave
    sha256 "01f8f03dee36433eb0928de31a435a670a4cd9c802dd1e35e08f4b811cdb564e" => :high_sierra
    sha256 "471effb9cb7cb1603825aa1101eb17d7ca8285f74ee2b2ccadca05a3fcb8552b" => :sierra
    sha256 "5c63bfa647a3db195c5824b3b7fc1cfa8de666dfec05553ea8f195eaeeb04343" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
