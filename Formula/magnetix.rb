class Magnetix < Formula
  desc "Interpreter for Magnetic Scrolls adventures"
  homepage "http://www.maczentrisch.de/magnetiX/"
  url "http://www.maczentrisch.de/magnetiX/downloads/magnetiX_src.zip"
  version "3.1"
  sha256 "9862c95659c4db0c5cbe604163aefb503e48462c5769692010d8851d7b31c2fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "358e8ee8c5ea8ab2268220dd1b9f529f2f6f5a5f47af3f992df2874a61fa1399" => :mojave
    sha256 "7ecfb0a04399be3be1e38f8f623337051c8c03766d3b3a94772cca8e51284463" => :high_sierra
    sha256 "92a54f8752b83ef2e179acc52aac4b79855fcf5e365586cc1cdd5e6e95ce6ac9" => :sierra
    sha256 "b3a243cbb1f7c97d92ea1cb82db31f5c2cdc9c2d43e0221e55f1ef6819d1af33" => :el_capitan
    sha256 "ed629c950ac52c6efee73a2e77e7004e0e33a85fe920d793a2e8621a484d7cdc" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :lion

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

  def caveats; <<~EOS
    Install games in the following directory:
      ~/Library/Application Support/magnetiX/
  EOS
  end

  test do
    assert_predicate prefix/"magnetiX.app/Contents/MacOS/magnetiX", :executable?
  end
end
