class Duplicacy < Formula
  desc "The only cross-platform encrypted/deduplicative cloud backup tool"
  homepage "https://duplicacy.com"
  url "https://github.com/gilbertchen/duplicacy.git",
      :tag      => "v2.3.0",
      :revision => "504d07bd5100b62473cd438738f8bc2507c67ff9"
  head "https://github.com/gilbertchen/duplicacy.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/gilbertchen/duplicacy"
    dir.install buildpath.children

    cd dir do
      # https://forum.duplicacy.com/t/build-duplicacy-from-source/1091#build-on-macos
      system "sed", "'s/github.com\/gilbertchen\/keyring/github.com\/twc\/keyring/'", "src/duplicacy_keyring.go"
      system "go", "build", "duplicacy/duplicacy_main.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/duplicacy", "help"
  end
end
