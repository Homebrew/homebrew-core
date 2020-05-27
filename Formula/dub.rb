class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.21.0.tar.gz"
  sha256 "320d96453b4a9a36a2d8716307cebe44f53638e06f425a7cc0d7d4dc9379bbe7"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfa1ed65889521a635bcdd69945d9d4b77aa72cce963c544286e76dbc85b2cb2" => :catalina
    sha256 "3d818daf0852931d00d7780838f1c60b8907a3b0eecfbccba1166a9bf26d2834" => :mojave
    sha256 "e0abff9d8011d7bdbd603fe27e226e8f11b3d33c536947ce944b577bb5a34a64" => :high_sierra
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
