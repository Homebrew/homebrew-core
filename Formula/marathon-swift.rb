class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/2.0.0.tar.gz"
  sha256 "51ca9bc5c67781ecdccb81bfdb4d424c0271cba7c19d4b7b06fda6a23b8a7d08"

  bottle do
    cellar :any_skip_relocation
    sha256 "14541e2edb49c0eb2118b61ff0245e0654dc49d4b48e461df6cb1d8c6698112e" => :high_sierra
    sha256 "80fc6f4b1ff33081f4b27091ea42901c3921e00f6ffc3a2017662e6905e562df" => :sierra
  end

  depends_on :xcode => ["8.3", :build]

  def install
    if MacOS::Xcode.version >= "9.0"
      system "swift", "package", "--disable-sandbox", "update"
      system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib",
             "--disable-sandbox"
    else
      ENV.delete("CC") # https://bugs.swift.org/browse/SR-3151
      system "swift", "package", "update"
      system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    end

    system "make", "install_bin", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/marathon", "create", "helloWorld",
           "import Foundation; print(\"Hello World\")", "--no-xcode",
           "--no-open"
    system "#{bin}/marathon", "run", "helloWorld"
  end
end
