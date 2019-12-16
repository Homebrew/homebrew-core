class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/5.241.2/paket.exe"
  sha256 "4381dda0c783636a2620a21a36c2366d55e344e8cd1831c5b3ac119457b1feab"

  bottle :unneeded

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
