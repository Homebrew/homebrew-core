class Bartycrouch < Formula
  desc "Incrementally update/translate your Strings files"
  homepage "https://github.com/Flinesoft/BartyCrouch"
  url "https://github.com/Flinesoft/BartyCrouch.git",
      tag:      "4.7.1",
      revision: "c83fe72d329ffbe2afda6b980c62060699ef6bb7"
  license "MIT"
  head "https://github.com/Flinesoft/BartyCrouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2826920f37928bdc35e730257969a1b676b36864967a848c196df2b7edee80bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "4588599e70c69ce5f5e28c4946978cc09fad5f003368a309df251b45bfca2c5f"
  end

  if MacOS.version >= :big_sur
    depends_on xcode: ["12.5", :build]
  else
    depends_on "swift" => :build
  end

  uses_from_macos "swift"

  def install
    swift = Formula["swift"]

    # Skip the shims for testing; do not merge
    if OS.mac? && MacOS.version <= :catalina
      ENV.prepend_path "PATH", swift.opt_prefix/"Swift-#{swift.version}.xctoolchain/usr/bin"
    elsif OS.linux?
      ENV["CC"] = swift.opt_libexec/"bin/clang"
      ENV["CXX"] = swift.opt_libexec/"bin/clang++"
    end

    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

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
    assert_match '"oldKey" = "', File.read("en.lproj/Localizable.strings")
    assert_match '"test" = "', File.read("en.lproj/Localizable.strings")
  end
end
