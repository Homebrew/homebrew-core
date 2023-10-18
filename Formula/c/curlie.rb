class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "24f34e0a21848a54750cea366ca15f6b4c1ab255b4b46942e4e09b2ebde55931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f401bdf579738fdfd5b4337bc32a3d0b8ebbced94f4a2f83b7a9d12942588988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07ad785416ede91518b9ab7df692902374eea6bb37161b8e55b5da83f13c5c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d07ad785416ede91518b9ab7df692902374eea6bb37161b8e55b5da83f13c5c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d07ad785416ede91518b9ab7df692902374eea6bb37161b8e55b5da83f13c5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c5e3829354c0a034d36176085185015785872fe1c7ed1a812c0fb4fed861cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "01023ef2b609aa6c98c8ea6e306a4e0acba9024fe065d8f845b690045ea13972"
    sha256 cellar: :any_skip_relocation, monterey:       "01023ef2b609aa6c98c8ea6e306a4e0acba9024fe065d8f845b690045ea13972"
    sha256 cellar: :any_skip_relocation, big_sur:        "01023ef2b609aa6c98c8ea6e306a4e0acba9024fe065d8f845b690045ea13972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76324620003acfc72b3f5f7aa4305a4a75fc22ff939b963206ecab4c91ccfd1e"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
