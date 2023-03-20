class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  # https://acpica.org/sites/acpica/files/acpica-unix-20221022.tar.gz is not available
  # upstream issue report, https://github.com/acpica/acpica/issues/823
  url "https://github.com/acpica/acpica/archive/refs/tags/R10_20_22.tar.gz"
  version "20221022"
  sha256 "1aa17eb1779cd171110074ce271a65c06046eacbba7be7ce5ee71df1b31c3b86"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e69b188caca07beac560141ef4d9519109383eef13813d23d99d508e82ea765e"
    sha256 cellar: :any_skip_relocation, ventura:       "275be697f6fc4add94fec360407398b70d259a757e654a819843d393de8a54c8"
    sha256 cellar: :any_skip_relocation, monterey:      "6a4f3736eee30b72c57d76719ded526c0db20b176f710f3eedd6586bc3b3d59b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0689b9e9e35b3e59caaef23c74a315bb012108d11a29bd103385150d4cf245e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d8fec0a2b421723e0ba234512fff5352f96ba355564b38670a5c92c548da08"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
