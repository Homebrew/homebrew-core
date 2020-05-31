class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.18.2.tar.gz"
  sha256 "1098fac512072db21e9b466e66843350649abebf867bc22feeebda10d86e6787"

  bottle do
    cellar :any_skip_relocation
    sha256 "693e5416a91677cf7a4f4e3fe67ea09269f2ea4ac7228b3b175a8fc965dbe049" => :catalina
    sha256 "00ab6130b8ed81a4e9e027adc2fcf885edf70815fc12a814225aa34af28cc32a" => :mojave
    sha256 "ebadeb272afb1e3aeb0af6925965ce46b09c429d5ffd8fb58abafe07f1d9cdbd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
