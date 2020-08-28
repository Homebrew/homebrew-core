class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.22.0.tar.gz"
  sha256 "758c61faeb27fab61967faa51152651ecc66f1092e023760f641cbeb9e28c058"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b0d9a91c1eed292a083a19dbdc341170ffc3c7fc1fd059fb961188d368f27fcd" => :catalina
    sha256 "65151d2ac806c92d4e15da246db43781ad50b38eb781ae59b740429495818117" => :mojave
    sha256 "5fd60cdd406eb405bf9a68697e756590570a277a164ae7755a2169e2b808d488" => :high_sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
