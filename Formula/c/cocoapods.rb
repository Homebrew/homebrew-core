class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.15.2.tar.gz"
  sha256 "324a13efb2c3461f489c275462528e9e721f83108d09d768d2049710d82d933c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f9825eaf19aba42fc19939c47c49b3d4e322d383f5a79ab029167351d5547c6"
    sha256 cellar: :any,                 arm64_ventura:  "e1729cced418772a8d8aa810c7cb153ec66db56a9b2cbec3e53adaaa576fb1ba"
    sha256 cellar: :any,                 arm64_monterey: "e8dc98276c80101c70aa14f6e736e1154b988f3b53f6be357b7a76cf776c3b4b"
    sha256 cellar: :any,                 sonoma:         "981c5baaab7a26258bfccfb7efc7141b9a88912b5fe06197ac07423fc436ed34"
    sha256 cellar: :any,                 ventura:        "1cf37b506f2b50d73a26b3b1e1f28009faeb66d6a3ec4671453ac6d360e96cba"
    sha256 cellar: :any,                 monterey:       "fa000679291ddbfa5792e8b04f71c106c4c3325116215ceb76e46f4c8ed7f85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cad9d3142ee7623d1ca22773dbeefa0e936e224aecef263a1657a91413c9958"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
