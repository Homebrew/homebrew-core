class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.8.0.tar.gz"
  sha256 "c807030d86490ebb633f8326319dac4036d41297598709670284e4f7044d7883"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfa8cf3fdcdf4cdb847d3238c645db2ef8895cd1c8b871f5497b35e6031a289e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a627b7ae09db7019e5940f4d2d7c78b5a44b651f80634b4eb98055a7902342d9"
    sha256 cellar: :any_skip_relocation, catalina:      "08f17da7227cb766787838cb6c1d53ac0498cbde6245da0470f8379e84b476aa"
  end

  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["12.5", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system "#{bin}/publish", "new"
      assert_predicate testpath/"test"/"Package.swift", :exist?
    end
  end
end
