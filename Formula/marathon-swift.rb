class MarathonSwift < Formula
  desc "Makes it easy to write, run and manage your Swift scripts"
  homepage "https://github.com/JohnSundell/Marathon"
  url "https://github.com/JohnSundell/Marathon/archive/3.1.0.tar.gz"
  sha256 "98f454bd788d8e6dc670c99f1fbafdfd1dd0cb75b09a5db3d407e5ef31265120"

  bottle do
    cellar :any_skip_relocation
    sha256 "d17beec1d5a1723abfad9656c8ead0f727ea4af509dea5c57bba53719f9a4892" => :mojave
    sha256 "14541e2edb49c0eb2118b61ff0245e0654dc49d4b48e461df6cb1d8c6698112e" => :high_sierra
    sha256 "80fc6f4b1ff33081f4b27091ea42901c3921e00f6ffc3a2017662e6905e562df" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
