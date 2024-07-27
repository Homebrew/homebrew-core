class C < Formula
  desc "This command allow to run the c script withoud query about to compile, just run : c file_name.c"
  homepage "https://github.com/Emanuel937/homebrew-my_script/compile-c-.git"
  url "https://github.com/Emanuel937/compile-c-/releases/download/v0.0.1/c.zip"
  sha256 "626fc061fe1b5a44ecc83a73424f9ae69a81eabbf44e0f166f4ff1ebac5621a7"
  license "MIT"

  def install
    bin.install "c.sh" => "c"
  end

  test do
    system "#{bin}/c", "--version"
  end
end

