class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "http://proselint.com"
  url "https://files.pythonhosted.org/packages/a2/be/2c1bcc43d85b23fe97dae02efd3e39b27cd66cca4a9f9c70921718b74ac2/proselint-0.13.0.tar.gz"
  sha256 "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a5829fdcd105a044993dc63bf9ee2bb42a075b15aa416f05b41587e448a74bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a99d0eff9a09c4e195caf20a2eb448e4305c61786b592adbd6ad98dc788e5849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7423630937ce4c70aeba94ab02532422fb1d0d19132fe632335cbd1679dc7fbd"
    sha256 cellar: :any_skip_relocation, ventura:        "94aabb15c29ab3291aace706ee0acf906ec6bfce8ce1ba86506028209face8eb"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa8f05c1e3f1082c8c8186d4fca8f47b2887a01917cc2f2ac573cf594eef8d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3fa366974923cf5fd04d11e0f70dc8b6d6b57863b965ad67297c24530bd0548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801bbc1c0af4b44e9770f872b6cfa289d59745fd1f84b4f40d34c9b009b6e500"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
