class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/FlineDev/BartyCrouch"
  url "https://github.com/FlineDev/BartyCrouch.git",
      tag:      "4.14.1",
      revision: "6632e30cae5733e04a3d04aaa2afed25c04606a1"
  license "MIT"
  head "https://github.com/FlineDev/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5a311ab6b5dcc5207d783d613f2435b1d38247d2d67bb929e6a071c5f3d24b28"
    sha256 cellar: :any, arm64_monterey: "43dba96a5a6c96a5a04d677da4055658ac3c9c8af53c7d76c94fe1f12a5fb182"
    sha256 cellar: :any, ventura:        "18dabbc4f3dbed4f368989134994412d03dfd5456bded2efd8c6f67bbe8e7601"
    sha256 cellar: :any, monterey:       "904848becdca34aeda73e79878654d02d937db7d2403d345d34d2a04c6cef120"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(lib/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      class Test {
        func test() {
            NSLocalizedString("test", comment: "")
        }
      }
    EOS

    (testpath/"en.lproj/Localizable.strings").write <<~EOS
      /* No comment provided by engineer. */
      "oldKey" = "Some translation";
    EOS

    system bin/"bartycrouch", "update"
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
