class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v2.2.1",
      revision: "4bfe97652081691dd3a23a87def00ac241aebccc"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45701a169c217fe4e51973d6e37f71d8adce54021069c19e335ef131d0c4c420"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f797d30a4c1664e4121bb6517560c8785d7b42cb0f99da823fd8a63f0fff0363"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64dc4cd12b6a8d1500d4f6374983c758aa584c4f5b51c937f6323fae9ee1afc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "329762031e6e183592a307657d49e80cf495fec8d5b4ab3e950f69aa96952fda"
    sha256 cellar: :any_skip_relocation, ventura:        "036b4600c4134480c7c565c8c28252e5a4e48e355a3a7d2b336d1414c114d1a6"
    sha256 cellar: :any_skip_relocation, monterey:       "70624ed0e4a4b4b640ab060a8492f0407bdf415f7052ce21304251693d8910f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d76f9ab7024b9204e47ac07de26e43805d5fe2d17f1f0ead0f53810fa1861b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
