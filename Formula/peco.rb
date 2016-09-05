class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.2.tar.gz"
  sha256 "66dd72033653e41f26a2e9524ccc04650ebccb9af42daa00b106fc9e1436ddef"
  head "https://github.com/peco/peco.git"

  bottle do
    sha256 "a792f1c37977a4011ba7f656a60d16434473a7ee8d18f661e75f6ad10dfa9bc8" => :el_capitan
    sha256 "6468459ed66044ff730875d1b09cb518faba8e96d2adb3d81d71cf5b121e1625" => :yosemite
    sha256 "b69e050fa202829bb5d48579ecc1eb82c1602853f67e052974c8ac61e2ad9104" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "glide", "install"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
