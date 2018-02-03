class Defaultbrowser < Formula
  desc "Command-line tool for getting & setting the default browser"
  homepage "https://github.com/kerma/defaultbrowser"
  url "https://github.com/kerma/defaultbrowser/archive/v1.0.tar.gz"
  sha256 "c36cc05e778233f7a3c6109ca78227f82dbdde33a5194dae1457cd83fdf27df2"
  head "https://github.com/kerma/defaultbrowser.git"

  def install
    if build.head?
      system "make"
      mkdir_p bin.to_s
      system "make", "install", "PREFIX=#{prefix}"
      bin.install "defaultbrowser"
    else
      xcodebuild "SYMROOT=build", "-project", "defaultbrowser.xcodeproj", "-alltargets", "-configuration", "Release"
      bin.install "build/Release/defaultbrowser"
    end
  end

  test do
    if build.head?
      # new defaultbrowser outputs a list of browsers by default;
      # safari is pretty much guaranteed to be in that list
      assert_match "safari", shell_output("#{bin}/defaultbrowser")
    else
      # old defaultbrowser outputs the current browser
      assert_match "Current:", shell_output("#{bin}/defaultbrowser")
    end
  end
end
