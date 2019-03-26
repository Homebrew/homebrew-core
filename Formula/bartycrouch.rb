class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      :tag      => "4.0.1",
      :revision => "b7e940a6383c9d1f013288081dcc2a395c68448b"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any
    sha256 "7e7bb953565684390a21190e48b7b261e5fdea31fc15772c92a025f73d1c18be" => :mojave
    sha256 "206e9bef7cf82bde25f7f8ba3380cbf0b2a094c33fca3474d5c9593d2e348bca" => :high_sierra
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
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
    assert_match /"oldKey" = "/, File.read("en.lproj/Localizable.strings")
    assert_match /"test" = "/, File.read("en.lproj/Localizable.strings")
  end
end
