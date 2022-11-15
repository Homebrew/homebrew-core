class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.3.tar.gz"
  sha256 "91d31754611520529b101ee57a059c5caadcd7ddb3c5b3b1065edc0ef5c43372"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7a566fdc19b54792dfb58a70126d9a847fbdcc4eb4fd0c3c402cc143fcdf704"
    sha256 cellar: :any,                 arm64_monterey: "0e8ecf1b4a9028ffca29e1bba075b1cf572c9caf30ff6c0a8cf7f82f24563cea"
    sha256 cellar: :any,                 arm64_big_sur:  "b55909267f5f2853f40ab081e6f6b1b47d725a16cabcd0df3900eecae2095957"
    sha256                               ventura:        "140e2461fd6d1000ba48ab49162d604ab1ea5b9a033fe7576e5558e9fab339ea"
    sha256                               monterey:       "92ea102a56b7f97ea877b289b92ac7005f10be6ad68917f451160f9734535895"
    sha256                               big_sur:        "93e099815313bbf5efa3d3ab64113c57c3d5720089f8c76317bb18801456c3b9"
    sha256                               catalina:       "ab21df98d9843b3ebc1ee0faa6a6573db5ee5af05bf5f188b01de4c743d28bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab2c8941c901fd4936ac10bd42c099ff81fb93de3d866e83630beb4027c1ef5"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  on_arm do
    depends_on "ruby"
  end

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
