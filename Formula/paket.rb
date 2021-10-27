class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/6.2.1/paket.exe"
  sha256 "1ff11a801e0747d4b09798caacdfb0708c6a7fa7c7b40b317a354daf012cc12e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e88d0baf7898ba4bdcff08a69f27710b6c1356bb451805a7ad11292bf315d112"
  end

  depends_on arch: :x86_64 # mono is not yet supported on ARM
  depends_on :macos # mono not yet supported on linux
  depends_on "mono"

  def install
    libexec.install "paket.exe"
    (bin/"paket").write <<~EOS
      #!/bin/bash
      mono #{libexec}/paket.exe "$@"
    EOS
  end

  test do
    test_package_id = "Paket.Test"
    test_package_version = "1.2.3"

    touch testpath/"paket.dependencies"
    touch testpath/"testfile.txt"

    system bin/"paket", "install"
    assert_predicate testpath/"paket.lock", :exist?

    (testpath/"paket.template").write <<~EOS
      type file

      id #{test_package_id}
      version #{test_package_version}
      authors Test package author

      description
          Description of this test package

      files
          testfile.txt ==> lib
    EOS

    system bin/"paket", "pack", "output", testpath
    assert_predicate testpath/"#{test_package_id}.#{test_package_version}.nupkg", :exist?
  end
end
