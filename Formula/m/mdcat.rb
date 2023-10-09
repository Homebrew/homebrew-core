class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.0.4.tar.gz"
  sha256 "9ed5ddeb9588f42220ee039c429e43188fe1f36b902c9e63b4092d0cd2d8123a"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fdc42c1127b0ab59e42e410f4492e8a6bbcf9ed87d27eefd30dd42a0bdbabcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe6970662325cd1097d4fd3a11996f7d723be07a2de9bdf28c10860c7280a51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa764ca7cf0b99149fa92e5fb9ef9db5106798d3d180880c15f153d58f685e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b94e68769c47cca8a4a11fecafac84ab25c08be2c501aabe68e7715cbf411649"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c0f469300bc60879126073d85c7f838639d6ab8af0d905267efccc67b28eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "e0dc3e7d6430bd50cc0502d6607d62303315ae5413d18a248a24fe6fbda37bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333fcf4e5ca088ae1d4839001f31759b8115c75bc89436fbda9e6a75192d8323"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
