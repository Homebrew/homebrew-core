class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.11.1.tar.gz"
  sha256 "816ab671274386a49264351de93a9596ac79215c2a884763e4e82e0d3af4722c"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f082b74f447d5881e6d63cd3ef32e89ff85609563d9d69899d83404dcb6ff3" => :catalina
    sha256 "cad2ca5610e33092acb15179f5d5fa29a9ae330aa12bfc08b124a3515c13efeb" => :mojave
    sha256 "6ff12daa659904fdbf93d458dd036d7ef16fb730079d8ee4aead9dd161f53c43" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
