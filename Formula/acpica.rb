class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20210105.tar.gz"
  sha256 "a9be7b749025e60f93fde2fe531bfe0d84a33641d3e0c9b0f6049f996dbb1ff8"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "615e2c2548792f1620e7e0fe6e5b8232a7460b9483c66f539345b2dfbd9ff46f" => :big_sur
    sha256 "137d71a458497a5b7e5a4a85953c8fc30590a3fa687698a9e019a5eecd77cf04" => :arm64_big_sur
    sha256 "e4302dedc1720a8374d32d106fab97b4e9daf28ebacc768646b5cb62d05187ec" => :catalina
    sha256 "893420b8663ccae192b5dbe8dac8221428f17f9c862d1c3ef3e0030bb6d74c3d" => :mojave
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
