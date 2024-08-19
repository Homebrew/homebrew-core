class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1f50a6405f33ec30d7abc2656664197e313b5ec927214c45f343471bad8366b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7353f7b038e37a1236b3bc177f309ce63fa63ac6cc89c57664701414bdf7f38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5a319d41ef6ed3825d96665fa038c2019897b6c193ad49e58383acc1cb00b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d78847a700cd9995001c07986b57a21853de400b3a97d07582754c107878921"
    sha256 cellar: :any_skip_relocation, ventura:        "b18d785ee4915cea8c3d06361a5a8a82a34835227fe4914f9a60c381c62e8fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "f8461aa1a12f321b47368c55b126c516ff5f037c1f208b6b326787c89d54ee66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056f4fb7815940b78ec0e81ec4b08db0dfd4a3b9665cdb71975df4a1eeef4ae6"
  end

  depends_on "python@3.12"

  # Replace pkg_resources with importlib for 3.12
  # https://github.com/nickstenning/honcho/pull/236
  patch do
    url "https://github.com/nickstenning/honcho/commit/ce96b41796ad3072abc90cfab857063a0da4610f.patch?full_index=1"
    sha256 "a20f222f57d23f33e732cc23ba4cc22000eb38e2f9cd5c71fdbc6321e0eb364f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
