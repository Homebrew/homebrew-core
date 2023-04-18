class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk.app/"
  url "https://github.com/mdzk-rs/mdzk/archive/0.5.2.tar.gz"
  sha256 "292a0ae7b91d535ffa1cfd3649d903b75a1bb1604abc7d98202f3e13e97de702"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e395b411c4fd8c752152796aa860f24a44ac7d4540ffc838c6808a443ea271ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b825c14aa162c7b6e107d17a4a94db341b1dbbb57697f1001bd66a2ab9b45c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57d5583b4a4f354106060c3d15e245b223580a29bfc2e7228bd9a611a31506b0"
    sha256 cellar: :any_skip_relocation, ventura:        "ce6ab505ed1ff51c57a3740204330ef129212b2bef6e1a1b5a686ec12f038901"
    sha256 cellar: :any_skip_relocation, monterey:       "5a880de7f75b7b16d40b997e0a50aa4097d24598a46294ba097f5f7a8c3f9595"
    sha256 cellar: :any_skip_relocation, big_sur:        "b15fade4973c35b431443b0982396b4c1e03399f2c2b85413158a976fbc501a4"
    sha256 cellar: :any_skip_relocation, catalina:       "c168154d8cf9b1aafdf5f089922d8eb8e74655b97b389435534a9efbc668440d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95bc548f5fb2c84e0e3b62e895e3c6812e8df51b74eaf6bad4167ab1861f66d5"
  end

  depends_on "rust" => :build

  # Fix compile with newer Rust.
  # Remove with the next release.
  patch do
    url "https://raw.githubusercontent.com/NixOS/nixpkgs/ea76cad34d64ce213de5992154031bf0c9b75ace/pkgs/applications/misc/mdzk/update-mdbook-for-rust-1.64.patch"
    sha256 "953f1d75d586acba6786d9c578f5c07fc2a52fc5ef5c743576a613a7491fbb50"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
