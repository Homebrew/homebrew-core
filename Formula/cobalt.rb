class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.0.tar.gz"
  sha256 "1ecab64da429ab362fa2c1eced7b1bb91bae0c3d144808db82d7410059099aff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79cd84de90a221fbb1fcff68dbafd63ea81b4144605922b3efe9509c42859253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e3e33050fdd07a500168ff760c004c4c9626c551bad5678c0b57e6d7a8d992"
    sha256 cellar: :any_skip_relocation, monterey:       "33aee37fa45a56956ab4be4982af7da8eac15193986dccd6edc305aec8cc5914"
    sha256 cellar: :any_skip_relocation, big_sur:        "75bfd5722ca6fa5f8ecfb0bd76ad2ef1d70c80e9e3965f25cd558ba72dd12fbb"
    sha256 cellar: :any_skip_relocation, catalina:       "f44c148995304107687350e59d54fa427cd0780fe22522cd3fb438872e926ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56219fa4a2300e8714a2e2e50d25d270eeafbb0987a4cdb04728cacfa1b3ded"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
