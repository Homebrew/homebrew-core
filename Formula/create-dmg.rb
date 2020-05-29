class CreateDmg < Formula
  desc "Shell script to build fancy DMGs"
  homepage "https://github.com/create-dmg/create-dmg"
  url "https://github.com/create-dmg/create-dmg/archive/v1.0.8.tar.gz"
  sha256 "6eb256e6835e650e4a529c9ea0630c409e6d1d5413fc9076b94d231674fa4cae"

  bottle do
    cellar :any_skip_relocation
    sha256 "f79816fe786969d0c2bbf6c025d1616b04add290a20def2492f73295b36bc76c" => :mojave
    sha256 "d99f697bf1d22dba54a87890b30f383bf4aec7ca5b54f180646041f9d046c243" => :high_sierra
    sha256 "d99f697bf1d22dba54a87890b30f383bf4aec7ca5b54f180646041f9d046c243" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    File.write(testpath/"Brew-Eula.txt", "Eula")
    (testpath/"Test-Source").mkpath
    (testpath/"Test-Source/Brew.app").mkpath
    system "#{bin}/create-dmg", "--sandbox-safe", "--eula",
           testpath/"Brew-Eula.txt", testpath/"Brew-Test.dmg", testpath/"Test-Source"
  end
end
