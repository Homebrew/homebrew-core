class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz"
  sha256 "2e64e5d79a738d0fa6fb546c6e5c2bd28f88d268a2a080546f74e5ff98f29d0e"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e61eeb76320abf82b141107f660dc7b2b4b3965b6c3a4f71fee9d6c745859198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920db5d2c658173b83fc2a7117c8f9c0aebae203b00f840c2aa579ab6696fc90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "996e69242abd2111951228c79f63163df1b03fccb08467a771d17352bbd74b12"
    sha256 cellar: :any_skip_relocation, sonoma:         "f89bc54f36c4c8427f7a64ab38a76d97c5a66f09e1bce8208579ef6bb7de61cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f2125b424c6dee7b96e0d76a0c3a7ac65a06a6adb731ef4564950f6e3db08c4c"
    sha256 cellar: :any_skip_relocation, monterey:       "19c84f0eab8521d0959daa35ae717aee222a686e4b8fb2693a81055684708af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd7aa0a7521dd7f3ef0ebbe5a0a8b0ef4205f98fb67eb14cf1c65023730ab9e"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
