class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "61127efcd73e72b4af4dad3bd18a51eb7a372d8d44b6b4ca5c9212deba3f3264"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55209b4c673c85347375078d73577e22a10ce954a69f66e9a1aa95a1f13e8fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9285058b48c50b079f0b794ec5364a93777e643de9767ca377d5921920967021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c19e0544691ef810c62cd6d1856704ee8df97f738b255544e47096efc800d9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "037d03a9ecf28cf3d5b5c6e5b377dccb3485c8373ca459ea2e5efd13bda08866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4167578e22cf98e014f7ca1463a12aa562a4933f1bfecb8a70324c69670a0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59cd75502884c738f6526fc0ebcc7490b9203da509c51e517f8c1cd78fbdfad1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
