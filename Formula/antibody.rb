class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.0.1.tar.gz"
  sha256 "dad02a91cbf5715209ca2958dfeb29127f674a00615f80254efc87c33930dbe0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c3ec35f32bb0ba5a254c7ea09675251dfa73ec5c0066a3a28a7fd637065e026" => :catalina
    sha256 "44120733359210252f9b57d7d4d96ab46acb13828a3b65fdb001e639cc46a31a" => :mojave
    sha256 "ccea6fb02d1df23fc2438993b2434a8826904d3be4779d5efc5310ae2fbddfb2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
