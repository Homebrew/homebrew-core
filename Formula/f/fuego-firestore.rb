class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.34.0.tar.gz"
  sha256 "25f67ad001b77c242b74a82a3ea7793f655d437e9eadf5578d27ff365e68702a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e18818cb5679bbbe3dd54d1f4f9adbb0ce55678fb034cd99e57306bd3736084"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61a78fbab2ed526da2325b8963c6cdc8d1dbadae866ba53bb98711a33d4ff259"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cccd36ed223be213a899ac913356c745339ca64c094643a187add03c76b41ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42e6904ff8b93024f9e3126345acde1fd9e1034ac72a1e32d77f4a4df89de69b"
    sha256 cellar: :any_skip_relocation, sonoma:         "29099f24025e42776fab292a2286854dcb16df717afefa51485191e9c3c27de8"
    sha256 cellar: :any_skip_relocation, ventura:        "b3af0a3deea658833081b9ebff782f9bd035646afb65f85bb9957ef60e5d9d89"
    sha256 cellar: :any_skip_relocation, monterey:       "395d581d8c5ee2a748485ea81a4c2458f84daec60b82a883f08c45c065cd6952"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f16e5f4674a95a430ff032990bda825d7aee8acbfe470f45a839d8fa66c7778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1388cb599ec3267309aecfe3a71fdbec9ef39bfb6ae0995afd2fd7502946a72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
