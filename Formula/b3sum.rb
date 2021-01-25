class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.7.tar.gz"
  sha256 "304b3608770cc91a151c7c4af5541dd6dd29716bad449ae5a418643ef15bcc5b"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ed7dd62dfc95de238ad74ab13577514d53b3d708268b1f7d5b370b9dc0c7f02" => :big_sur
    sha256 "fc926c9941257cf4ee73b3f98d3d96718d265924a989dbb246ba917be16fc83d" => :arm64_big_sur
    sha256 "1dee5365552d84eec74a73b53f67dafa412d87eb6ebff2e4fc853b2adc1e1215" => :catalina
    sha256 "59f5a92b9d5c5b15ae121a6614e2e5e23d23092cfb8d463f6131f6c2d89e12d3" => :mojave
    sha256 "90bf07f040dc35cfb4603f7cd03bf80279de9ecf36b4ddf02f0a4687918263f1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
