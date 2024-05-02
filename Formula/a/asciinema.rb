class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/f1/19/45b405438e90ad5b9618f3df62e9b3edaa2b115b530e60bd4b363465c704/asciinema-2.4.0.tar.gz"
  sha256 "828e04c36ba622a7b8f8f912c8f0c1329538b6c7ed1c0d1b131bbbfe3a221707"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10d155f8515514023454514b2f7898badc826c2756d064b17d7e6473a0ccbb8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3186a5d3dfcd25a6af378ce0f1cea2ddbeb719b15140917c0729a76a51979570"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258717dd75b271d86099190bd535fc24e6d71d78e9869491a1396e2209efae9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4c5445b99b3dd2e29feb8a1d2526777d7be095776d53616a06f5fcc8f83bc80"
    sha256 cellar: :any_skip_relocation, ventura:        "9e26a627695b47fd486bfd3be764213000e92c79b8fc49a907646c1fe2144418"
    sha256 cellar: :any_skip_relocation, monterey:       "62aaac2d7f795100ab5b9485f14f7f2c0454b495e0aba80b353c3555df74c5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9999efc810cc5521c71849c602de3928cedf782bafe450ba151a1b7f46d948f5"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end
