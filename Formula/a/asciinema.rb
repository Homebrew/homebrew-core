class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/2b/78/b57985f4efe85e1b49a7ec48fd0f876f75937ae541740c5589754d6164a9/asciinema-2.3.0.tar.gz"
  sha256 "db8b056c00e9bbb2751c958298b522518c4bd80326d90bedab7f8943c7a494d5"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f75583d1c278443d0a435e28662ae6cb2fdfebeccbe6832769cd3bf741de4ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "757788f46209af41524b5b14606c5c31981194920097a77232a25fddc8b8229b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e645b3a294be975ec5c582774039d85f1397acb4b2609950bccff226a7bbb604"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c804024fd04581f6b135898699c0a5aa94ab499841bf166e075aa0301525c8"
    sha256 cellar: :any_skip_relocation, ventura:        "765be2c4568eed3f7b2fb7bdfbba317ff0f1077afe5ef27413f195aaf9b6652b"
    sha256 cellar: :any_skip_relocation, monterey:       "ec3abd80b58f63868829e3bfd3ca67dc84f6db2c0841f368ff197fe3c81131ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b4187631ab3fd9827050c1658c247e9438307c354257175915e5d03e84122b"
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
