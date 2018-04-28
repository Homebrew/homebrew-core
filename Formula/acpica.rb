class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180427.tar.gz"
  sha256 "ae01b2d9e06192dca8fec9ccba327f766454e10935f98f608ec7de2690fd0c16"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c50f54f64b9891359a2f6ff496553a275990c7c117dc5087e0f2aa78ccf398bf" => :high_sierra
    sha256 "23e8cc3bd0408ba2efe4201bc17bd8f1c8cc757b9f77afa1d3258d83b8c95e01" => :sierra
    sha256 "59d4456d75b19a9e864e1764dcacacdfe43c4cdc6bf2f93d7444a3994d7669bf" => :el_capitan
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
