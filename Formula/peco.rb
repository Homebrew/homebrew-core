class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.2.tar.gz"
  sha256 "66dd72033653e41f26a2e9524ccc04650ebccb9af42daa00b106fc9e1436ddef"
  head "https://github.com/peco/peco.git"

  bottle do
    sha256 "53ce81be646850aa03e5616c50f0fd9daf60037c9ca414c4bda1bded412327fc" => :el_capitan
    sha256 "2bb5b860e62080f5aff73da7ce862f3f368e0c12066cd4d358a15d9a9cbd36dd" => :yosemite
    sha256 "b3d8490e24a46b6e8935a988eddf5ccbc494371c6e85b8b729501df4650cefae" => :mavericks
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
