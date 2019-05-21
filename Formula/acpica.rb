class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20190405.tar.gz"
  sha256 "de01ca0e5c4b064f2170b2888c40f595cb896748aa8b4a8e5354a03696549034"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa3665996815939e7eac7c39de40d589f3b8961f6aae1612bc2c71efd49dd468" => :mojave
    sha256 "ea5c5066d31fc6a90c35710c3f16e50fd2ad163493bfce14efcf6aa757a2b8d6" => :high_sierra
    sha256 "fb9ee2e2700db5c336a0c745e9ea395286d4aa8a6a370fb4d87ac90caf036ac3" => :sierra
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
