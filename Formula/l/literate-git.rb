class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/67/0e/e37f96177ca5227416bbf06e96d23077214fbb3968b02fe2a36c835bf49e/literategit-0.5.1.tar.gz"
  sha256 "3db9099c9618afd398444562738ef3142ef3295d1f6ce56251ba8d22385afe44"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d61bd94784d7fb957ad8bfca0caf27fa43b8382e06d4c8428bb742d48bf8ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef46ab683337063ff292bc142023ff50350ea082b6371b40708e2470b0c634b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28ddecacf42d08be7319f240c82569119e1268e1fdfb8461d89c1f872873ee47"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e691b1e9991d567684cd096f6d292b38dc0021f71260f64a0e84a03ddfa3083"
    sha256 cellar: :any_skip_relocation, ventura:       "fca9dd9a0f110fef6ef64a8ce78a49f919a19c3ccb8d2ea0a80fb3e8db7361ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0947111884deb1763e926b5adaa99e3b49d9769ca7e297c340edeafc36931162"
  end

  depends_on "pygit2"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkgconf" => :build
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/a0/61/d3c0c21280ba1fc348822a4410847cf78f99bba8625755a5062a44d2e228/markdown2-2.5.2.tar.gz"
    sha256 "3ac02226a901c4b2f6fc21dbd17c26d118d2c25bcbb28cee093a1f8b5c46f3f1"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~PYTHON
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    PYTHON
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
