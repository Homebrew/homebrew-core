class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.5.tar.gz"
  sha256 "0a0b8359eccdd5d63eaa3b06b7a24aea813d7f1e8bf99536bdd60bc7f18dca03"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca9c6f99e37388e7e15b20f2980ad368dfa11e56d8724a92c360d142f81a44a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45fa5421d67d07106e203704401040e36360a7acf4a39fec0dc2b718cd155369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8971a06391adac21a91d07b4d872808021f88a4b7e6f823104e91878afd1344"
    sha256 cellar: :any_skip_relocation, ventura:        "80d8af3e55e306c6711a445e6ff12d1117d9f38b9039b49e7a81aef8f84669ef"
    sha256 cellar: :any_skip_relocation, monterey:       "5394123d4778bf473b07c584a3d2d1a7348f466c73130829e592760237a54667"
    sha256 cellar: :any_skip_relocation, big_sur:        "484b02151ca66f3100841caf4717670ae3c080164daacb1db151a8c40f52ae3e"
    sha256 cellar: :any_skip_relocation, catalina:       "458f095f06a37bbea5d7487b5b819f774d883684c99bfca6636bc03e3c64def1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c8b96cc637d89a829bde8952c93946deee5c641c6cf07f1bcc484a5e4d5ece"
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
