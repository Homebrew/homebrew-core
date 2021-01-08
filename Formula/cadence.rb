class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.1.tar.gz"
  sha256 "e6bac7de2466bb11db6aa59a6c5510fd79de1e7ca62384ace39c1448a161971b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "407f65fe6bdf23ab0868f3af42057c1b06c442f34c322714e8c08cf4cdaf43d9" => :big_sur
    sha256 "64ee759fa792485b5e241e3a324999852ef7e2236e77af9f5101a93aaa5e03cb" => :arm64_big_sur
    sha256 "7f851ffe33b63403fdf56242c39d719e7451ebf6d8766935c9d4caad30f36a21" => :catalina
    sha256 "8fe846d2d7e85e7a3e65f8d9180f8a37bd5291fead5c7275e2b1f23280ed6c4e" => :mojave
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
