class Magnetix < Formula
  desc "Interpreter for Magnetic Scrolls adventures"
  homepage "http://www.maczentrisch.de/magnetiX/"
  url "http://www.maczentrisch.de/magnetiX/downloads/magnetiX_src.zip"
  version "3.1"
  sha256 "9862c95659c4db0c5cbe604163aefb503e48462c5769692010d8851d7b31c2fb"

  depends_on :macos => :lion
  depends_on :xcode => :build

  # Port audio code from QTKit to AVFoundation
  # Required since 10.12 SDK no longer includes QTKit.
  # Submitted by email to the developer.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4fe0b7b6c43f75738782e047606c07446db07c4f/magnetix/avfoundation.patch"
    sha256 "16caedaebcc05f03893bf0564b9c3212d1c919aebfdf1ee21126a39f8db5f441"
  end

  def install
    cd "magnetiX_src" do
      xcodebuild "SYMROOT=build"
      prefix.install "build/Default/magnetiX.app"
      bin.write_exec_script "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
    end
  end

  def caveats; <<-EOS.undent
    Install games in the following directory:
      ~/Library/Application Support/magnetiX/
    EOS
  end

  test do
    File.executable? "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
  end
end
