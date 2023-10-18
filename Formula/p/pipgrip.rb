class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ba/35/218a9340ea032fc402fee92acf487007311d47be5fc37824984e5d7eb83f/pipgrip-0.10.7.tar.gz"
  sha256 "4bbd2f83ad4da7df2c10a58da618bfba5ca411f8964934251b18ce8a2e70a07c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817d65f5097dce68102fde55081b77fe0eeb474b866656670fde0f7a6ae1e5a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d8e6f568e77071b5c18f0ef3a0c8d0deec34b94e7599192cce4154763a31f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33773beb89f6de4c0e4831ef6e482dea210ba731d676e8cb46a0f19536e28f7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c5629243d961fc0b47d3129ce4d661b78f3cf3a7588c8bed2f6e72150f10aea"
    sha256 cellar: :any_skip_relocation, ventura:        "411ea3c61ef24fdddd918006a695ec7810b456ec2d9ce9dd860ae29c9c6d02e6"
    sha256 cellar: :any_skip_relocation, monterey:       "fd70ede0e7ee58c0949c434dfc022f8a40da34647f8a21d72df1e27ed1846478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ad4f9fc82cbfa80ba929484ab3d6412b010ad84157cd12046c756d04d20042"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/ed/20/560b2c0801762f3de73ce04dd20d50ec39c2cdae83f23b6ed81cc72c7558/anytree-2.9.0.tar.gz"
    sha256 "06f7bc294293da2755f4699cc5da5c92d9182a5cfae2842c83fb56f02bd427c8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
