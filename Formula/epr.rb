class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/39/20/d647083aa86ec9da89b4f04b62dd6942aabb77528fd2efe018ff1cd145d2/epr-reader-2.4.15.tar.gz"
  sha256 "a5cd0fbab946c9a949a18d0cb48a5255b47e8efd08ddb804921aaaf0caa781cc"
  license "MIT"
  head "https://github.com/wustho/epr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "879a6cf3a9bf93dbe26818545a2c3d14b32065f5500939a787bbc7fdadecec39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6590c8a5bcd690eef80fe2e1c4241475f8d4649afe1fda485bd58262eaaab36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab822e488b93156e6166ba4fb8592458d60d5ad3e9f3d2572a54d07f78deaec"
    sha256 cellar: :any_skip_relocation, ventura:        "c0ec75767ccc034fdd6d9e8ca8c441109f6c4de4f44f0b4417024ec70dfe3133"
    sha256 cellar: :any_skip_relocation, monterey:       "f2fa989bccad3f6b182357d457207cfef1ce01a430704c3cae128699e9b8d81b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc47dda988c3a2e2f61e9870f028b29ebb8ab405fff91eb858333cfa81df7834"
    sha256 cellar: :any_skip_relocation, catalina:       "b287ba360f24f04f56ad892fccb8b8b8ed7754227dfcf2d98132ed3a24e539e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31bad4f5113de503a4b0deb4d1714744d88de1f6939337aa0f066f5fe65510ee"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
