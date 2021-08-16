class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/6.0.4/paket.exe"
  sha256 "c2e0610dd8f28e53ef7291184763561d6dce855243d07b7c9b9c93839512d1b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e5e7fc6517a1aebccd4af7f86b21d4883ab0dc2cf929c57043efb5bef463413"
  end

  depends_on arch: :x86_64 # mono is not yet supported on ARM
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
