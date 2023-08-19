class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.9.0.tar.gz"
  sha256 "e098a48e8763d3aef9abd1a673b8b28b4b35f8dbad15218125e18461104874ca"
  license "MIT"
  revision 1
  head "https://github.com/JohnSundell/Publish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "191eff0e5440c1fef78775f497ca8ba619c6ed4211105566449e7154d8c3fc8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc955e9e2cece8065b4683a4fdad37a905fbfcfd84a2de5d4ee3ba95362bb8a"
    sha256 cellar: :any_skip_relocation, ventura:        "30f82563fe7d34323003a9f312c9d433803d8e8798366f54d48f0df3f011f5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "1fea104781c15f8799fe321f8ab6fd0a3a0c120e24250af828282b52923500ca"
    sha256                               x86_64_linux:   "b59fbd87fcbee58d181d557dc3214408d476673d3d40c1b67b518c2ca414bd80"
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
