class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.9.0.tar.gz"
  sha256 "e098a48e8763d3aef9abd1a673b8b28b4b35f8dbad15218125e18461104874ca"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46b98682bee859ef400576381066ac4572a256463aaa00b44bcef9141b3a502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43e882a02f169464d3b72b91c4221e605658f7f6a8989e069caecfd1d2c4caf6"
    sha256 cellar: :any_skip_relocation, monterey:       "91a7e223302a9aa8617b3ec0f1d5b25470fae3b307c789b0c8d13f0e2a6370cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "76ec25c3a77331097114f184bd69185e0b000d1b84f9f7be932021bcc62894cc"
    sha256                               x86_64_linux:   "c1e393b661b98242b749ae27c2059e840a08926588debad995cbd45a81f872db"
  end

  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["12.5", :build]
  # missing `libswift_Concurrency.dylib` on big_sur`
  depends_on macos: :monterey

  uses_from_macos "swift"

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
