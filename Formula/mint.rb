class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.17.1.tar.gz"
  sha256 "0e3ab23e548a752f6eee3a7b98d1c137a30371e4a0ec9212840baaa56741d2e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c0ec84137dd50cf949a68e1b8d3729956e2843e1cc48c6827d26e6d7dbc74fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c57aaea4b6eb863ef946bafe3a77f3d32ad4e10e05876b7c6b2df8f8b9656f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "5faf98e60b6d18332bcac4ab076f6ba861ee7daea4c23a85f97e6c8fa3d1f463"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ccf422821dd5fc82488f8e0ab2a11efb645901527b8cf9c42979cc152a9ce02"
    sha256 cellar: :any_skip_relocation, catalina:       "d09ea36619994628564fb3d7e8e71b8c368c59f68e29174fb84b9b127bd9290e"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
