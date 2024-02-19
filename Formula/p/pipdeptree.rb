class Pipdeptree < Formula
  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/c9/3e/4457ce966a3307286597666fd1527631c66780a5ade3dcbffbea97108060/pipdeptree-2.14.0.tar.gz"
  sha256 "3296195250e00d37638f2cce70495e3345645b4bbecc1c38ac39339f1511d9b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d3ff54da88d0100efbe3142eb52d38f5b62644c1b2f081f14d7cf9007fa4566"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc54e8b6fd7210905d5b3d982e5e99135571da6628a93ec6c2f808967ba2fcda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d98eed44f7d1196cda0eb9a2ad1647a9cc1926e60f5c6324d1b9d8f63fa005"
    sha256 cellar: :any_skip_relocation, sonoma:         "573ffcdab87ce11932a7186ac42ff56dac278aee65151c21bed438df569bb501"
    sha256 cellar: :any_skip_relocation, ventura:        "ef8e6545a03d85116bd9f05116bade24154c8c6024c2f0fa18acc635d2e85fb9"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd23053f1ca7ea3bdc00fa6af94beb44e12c4b628030431a20b900a9ec242b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527e352eca9fe96f6f98b32dfc9414e490c065bebddf2f9d6ac4b6aa52d241c9"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
