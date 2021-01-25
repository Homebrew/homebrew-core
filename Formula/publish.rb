class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.7.0.tar.gz"
  sha256 "71ab0609567c2929639b919e5c52f5a8d02cacd35c9ba4de32c5c992ee49cd33"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a627b7ae09db7019e5940f4d2d7c78b5a44b651f80634b4eb98055a7902342d9" => :big_sur
    sha256 "dfa8cf3fdcdf4cdb847d3238c645db2ef8895cd1c8b871f5497b35e6031a289e" => :arm64_big_sur
    sha256 "08f17da7227cb766787838cb6c1d53ac0498cbde6245da0470f8379e84b476aa" => :catalina
  end

  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["11.4", :build]

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
