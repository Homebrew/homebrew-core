class Duplicacy < Formula
  desc "The only cross-platform encrypted/deduplicative cloud backup tool"
  homepage "https://duplicacy.com"
  url "https://github.com/gilbertchen/duplicacy.git",
      :tag      => "v2.4.0",
      :revision => "b61906c99e17dca970f38c5b2c4ae88c9e170dd2"
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
