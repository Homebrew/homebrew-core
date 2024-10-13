class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/refs/tags/0.17.5.tar.gz"
  sha256 "f55350f7778c4ccd38311ed36f39287ff74bb63eb230f6d448e35e7f934c489c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a754e28b7b9e4e13c31af783857de64d2550b8866c2c9eb3ac9216154ab0f25a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ada351985ef562807e7460f869c527bb314600311738a944219225226f43addf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "250948fe6fc14179d7c381d084a90d6796861ba9a8456617cadda9ac62cbc2b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6546b80b980a45036415162189dd340b1f8d3f4e82a80d40a24e7b5dd672eb04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f9d254b248a44bb44e399081b7e50a6c598834e2bf86bb7de3ebc349f11e0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "154b8b94602d6d38249cfa936f7d071d9113935b3756d5781021fe04c3971e29"
    sha256 cellar: :any_skip_relocation, ventura:        "068f9984e81b578f2ed6cef4cc9659835a689bdecf121651ea24ebcfefd49339"
    sha256 cellar: :any_skip_relocation, monterey:       "f8b09a640942548a151c7450c85f33d40162c7540049666131740d49c68e61e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "528ea907912e8002cd3a769e8ddda4556cf2482122c3f848a7d923146df37101"
    sha256                               x86_64_linux:   "7c8dd63f0310a46f67550f92ee48a370fadfc1a4d884b8a3904a36b7b610b3f2"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system bin/"mint", "help"
    # Test showing list of installed tools
    system bin/"mint", "list"
  end
end
