class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dfa759d9121ce5521fbc022ff1877e4c4c9d9aeaf1d63d97417d87aa6b6fe5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c610986a2317d2210e874703fbd6ca2b73464eaa4c3f61980f83f09ed11d480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6777368661355f79a3890e52e83c92dd9993249f1f0a715946e372a7ffbcb9ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcbfbd1ae09df749c831e6043d2e6c636021333e87e5206071a05dbb0175ef5f"
    sha256 cellar: :any_skip_relocation, ventura:        "58714f704bb6e17b2f24f5320aa950c845ddfba758674b70674420d91de0161b"
    sha256 cellar: :any_skip_relocation, monterey:       "059b55eb1c872e6a4dca007474bf4a5ed7a683811147546fa842a320f54dbae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1065c266c6ef9d4d4598b06d549dca5bd0bcc1c1db0714c9e5728cd83158d9ed"
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
