class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/87/10/a31f42c4c97f6c2af69d5084346f63cee694130bd18be2c664d23cb2ebd8/dunamai-1.19.2.tar.gz"
  sha256 "3be4049890763e19b8df1d52960dbea60b3e263eb0c96144a677ae0633734d2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff64e3fb6455467f74439e4952139d94cb4bab9c10b7ebc9df5b8514bddeadd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bd68ee434bc9ca5412d3c8ad17cc3914be570fd00e06195bb521a363936bf1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b59e9d14e261003a703b3bcde3813b39db70bf6da199d0e1ba3e3beb71ca338"
    sha256 cellar: :any_skip_relocation, sonoma:         "40fbc82a6048f3d3594ed2071f2c60a0e64ff400cb173ae07e7d44aa41af37b0"
    sha256 cellar: :any_skip_relocation, ventura:        "34fbd32dbd726306660c398828fb673bf46f856159a12cfed8893ab9f08afd20"
    sha256 cellar: :any_skip_relocation, monterey:       "d67e69221445d2393aa5bcd57c056b9f741f95e5bc9ea79217ce13e0dc038b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b117c762da8523b7cbed7a9771e5158746d792857086dcc9ce948ecbe6055eac"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
