class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.13.tar.gz"
  sha256 "33763fa190baad390df7143b437b1ddda3867a12ccf6e11c3278e53ecb94e40a"

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}\n", shell_output("#{bin/"icr"} -v")
  end
end
