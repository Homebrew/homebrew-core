class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.1.tar.gz"
  sha256 "112becf0983b5c83efff07f20b458f2dbcdbd768fd46502e7ddd831b83550109"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e48c044b8a2ba3d083eb0ac67c1d082a24873bbf4a300e497d0deaf3257bcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7c841f9d6cc4d411721ccb6a05053a351d252985a37788352ce737b2cf9cd48"
    sha256 cellar: :any_skip_relocation, monterey:       "b07aa8f87eb31369fe28c86f9aaf5e8e55c3ebc4f4e27e3c4ee819b35a49509c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3031af49143f44df34216afcb12124b494613a39fd90dc3b53c38bffbb67f5af"
    sha256 cellar: :any_skip_relocation, catalina:       "b9eb383af70ee294843fae2a04dabdf92701699edf4484dc09188d8fab662101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c68e1b2f6c9749641d5f08d281420eb19879be28d2161371fcd61183d92f816"
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
