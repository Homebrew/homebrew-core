class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.17.3.tar.gz"
  sha256 "31ad7cc72fa0427ef95363efaabebe3c90c7e5af14537bf67f046c738460b51e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6c2b944c3bd04099240ed8c4c1489ba8a6274e8d80793744cf3bf5b0388922a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4a82c0b54477a7c3c54000d84833724f3aaa6f9bb62a20ffddb3c880f264480"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "722c3f50d202e3461e5130c3639da14b4d3e55f5156d7803978571da5577f5cf"
    sha256 cellar: :any_skip_relocation, ventura:        "38c805a065c493e4ce8ecae3dd9f832b8341cfa1d6f1d854b41f5bc19d022cbc"
    sha256 cellar: :any_skip_relocation, monterey:       "4a233f8e964bd5da4b4c6a4682e4d1bf1ee070a82afeffc12ec0dcbeb018f704"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee17ecd152799a45f080066867c1046ffd332940f1aa925ec4a4b032c47b0f54"
    sha256 cellar: :any_skip_relocation, catalina:       "54dd30032281efb21ce064aa2d205ca59c985f12f1bb55419ca6800c9b38a59b"
    sha256                               x86_64_linux:   "84e7f55630889e1dd849fc58d2840b79e91523039e1fcc4516cfe45c779f8b40"
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
