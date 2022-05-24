class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20220331.tar.gz"
  sha256 "acaff68b14f1e0804ebbfc4b97268a4ccbefcfa053b02ed9924f2b14d8a98e21"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9158b00f7deeb744b5fa08d79fb02a5eefbb606c10c0c2125681c3ff45673bff"
    sha256 cellar: :any_skip_relocation, monterey:      "1e39557249a8259dc8fe300ab7325f385c6a7b332228408dec7b919b1864aef7"
    sha256 cellar: :any_skip_relocation, big_sur:       "99b525eaf7d774bb286ea3b35327403bda569f09e85aa2c6f481c62a59a3c50b"
    sha256 cellar: :any_skip_relocation, catalina:      "29d1add20083addb56b94cff09bed25549a9d46c27726678c13bb73a88649065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5a176eda07b9a1b640d95542e1a3bc828a98f77dce5b7dfb4ca2b0bcdf817b"
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
