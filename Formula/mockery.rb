class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.6.0.tar.gz"
  sha256 "ce5eea62e9d130e3557c11016c306485ccd77919cf85d706a2556bce28d085ed"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4094897406ceffdbab71ea9e336e2afcbc33307534fe98e6ed09697a85b4399c" => :big_sur
    sha256 "57baf3bd06647ad294f5ecbaf5d34f10cc962cd6638521433aa6a3e004445d24" => :arm64_big_sur
    sha256 "df9ec002cd7bd632b81fcddbdcbc43da09646a26cb40f46a8dac45d606cef1da" => :catalina
    sha256 "0dc65625a3f8c0504f8d40edbbb4a25b01c6883876947afd312b712104b5871c" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=0.0.0-dev", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=0.0.0-dev", output
  end
end
