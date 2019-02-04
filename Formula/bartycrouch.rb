class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git", :tag => "4.0.0", :revision => "3afdce4b875b6e8a573eaa30a225e709b7ee7b0a"
  head "https://github.com/Flinesoft/BartyCrouch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a26c3afa9894c89d09350f6d233744fd104ac07b63f0d6ae3c533264957b8e05" => :mojave
    sha256 "9fada7c618c2293819746b7802d4b71c4c3615ec342be6b8c899e4551297b159" => :high_sierra
    sha256 "659b955035f9dbc317b7e1d74d7add56ae7cb874464545bc0ed5dd87cd144642" => :sierra
  end

  depends_on :xcode => ["10.0", :build]

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
