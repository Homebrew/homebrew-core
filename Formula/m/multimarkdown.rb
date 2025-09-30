class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/refs/tags/6.7.0.tar.gz"
  sha256 "aa386f54631dbc4e0beeb6b9cf9eb769db95a3f505a69b663140a80008cf0595"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bb4f39ee0e9e4ab40f4ce5c8e5aa5d57ef8739035769400d0c5b8ea17d0f0661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eea3968401cd2eca776486368efbf1572da6dee6bb9cf5c5396448f0da811578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f04dd2552dc7725620fc3e64e6b803652c0510e20e33242f4bd00bbde327ea74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d889681d3fd0ed644c4a80e951aed473b5ad9d26256e7e8f2f1922d0f2673b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10659d4c872d03814f36e999ec7db8a2340272bbab6ecf190726a727be05caf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb095b60ddeae5e2062aad184841505442c118b47f4ac374f9862e9a944e13d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c448456b2f4f00e34499e81f3843235e55f0e5d793fd92b0ee831f98ba20c089"
    sha256 cellar: :any_skip_relocation, ventura:        "ff9c00f98d2eac80faa49cef2f404b05edf2ac7ba43c1b8dc4c411c61ce4cd8b"
    sha256 cellar: :any_skip_relocation, monterey:       "67847004a22109bbc67413b0d1f407414338fe0b353ab8ac8e85726928eecb08"
    sha256 cellar: :any_skip_relocation, big_sur:        "c457aa21210a34ebbb29cc09df87a3bb56dbf80e7dca3f5ecd744f97668af195"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e89c26994747dd3843c5104bb0b8ae4f65cb0611459c8b21c443873e1432d85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b80ef1a499056e60b9a189b3afbbd7beefc2091578dc8699ad87d6d405ea2e5"
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  # Workaround for CMake 4 compatibility
  patch do
    url "https://github.com/fletcher/MultiMarkdown-6/commit/655c0908155758e7c94858af2fb99dc992709075.patch?full_index=1"
    sha256 "1ca4b7ea07c19981685786f8f469aad9c9d0d6af8394bc9d3b92608de929495c"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/multimarkdown"

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
