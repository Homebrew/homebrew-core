class Badread < Formula
  include Language::Python::Virtualenv

  desc "Long read simulator that can imitate many types of read problems"
  homepage "https://github.com/rrwick/Badread"
  url "https://github.com/rrwick/Badread/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "236dee5ac99b8d0c1997c482df5b805908b0c34f75277ef706e897af71db1f9a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb61116ebca8bec9b22139071f9845635e88840e9911141661bd731c150e8027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f79260fe61facfce61ea9af35c21fcf5398a5e372193dbaa800cb2a755d3502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef938bdf102e7b9c6b4aa11a50cffdfc572044de21a54b7fbac677d9718adcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb8cca5eec6cb16e79912f2ac38c4721461dd8e6278be9517fb9001311c33d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8895a97c93ecbf53bf382cb0d77e6b588e559beb05332da4877fb032c99916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9677618080b71fbe762f03a62173688539a4a56166f2f5b549e13a7aeffd586"
  end

  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy" => :no_linkage

  pypi_packages exclude_packages: ["numpy", "scipy"]

  resource "edlib" do
    url "https://files.pythonhosted.org/packages/0c/dd/caa71ef15b46375e01581812e52ec8e3f4da0686f370e8b9179eb5f748fb/edlib-1.3.9.post1.tar.gz"
    sha256 "b0fb6e85882cab02208ccd6daa46f80cb9ff1d05764e91bf22920a01d7a6fbfa"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test_ref_2.fasta", testpath
    output = shell_output("#{bin}/badread simulate --reference test_ref_2.fasta --quantity 1x")
    assert_match "error-free_length", output
  end
end
