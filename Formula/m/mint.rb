class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/refs/tags/0.18.0.tar.gz"
  sha256 "e99c0a351cf7452451d72180c8ccd18e1da710dc55d036502809a0db52779a99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b8ee3e9e0b9057b49327c202d96c8b713589098579e3c3f6fad275babe47808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03f825e0fd5918402a464d928e1e8ae91622c95cf62098858bd2b40424716e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89bc9449b108a6cae523b0435820043a1834654662067582543304aab7f32290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8176c18a31425df3d05f1584756d365f4e5179decbc7d9dd4666823a1462f06c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c46cfdc50fbaf93e0881988ba995420b04bfca1fe3fe6f401e8acf7565ff1669"
    sha256 cellar: :any_skip_relocation, ventura:       "6be5974302eff0e0139abf6bb9daf011cf3c39577bf521031e858d6f80c4dc15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4908cc3e06dccb23970b73cacd57d7984d813448d5322cad346a5960c2ab255a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8475fe55ddddff036a03d1cb6d255167b1c3418bcab0be6fe8e0b1801bcdc5e"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift" => :build

  conflicts_with "mintoolkit", because: "both install `mint` binaries"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system bin/"mint", "help"
    # Test showing list of installed tools
    system bin/"mint", "list"
  end
end
