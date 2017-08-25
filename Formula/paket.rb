class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/5.90.1/paket.exe"
  sha256 "368da6c6aeda2dcb4c5e1e4db1b5dd2d6e5826932284e3251bcf97788d7a2b7c"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install "paket.exe"
    (bin/"paket").write <<-EOS.undent
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
    assert (testpath/"paket.lock").exist?

    (testpath/"paket.template").write <<-EOS.undent
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
    assert (testpath/"#{test_package_id}.#{test_package_version}.nupkg").exist?
  end
end
