class Fdroidserver < Formula
  include Language::Python::Virtualenv

  desc "Create and manage Android app repositories for F-Droid"
  homepage "https://f-droid.org"
  url "https://files.pythonhosted.org/packages/18/6c/6fe6f718073024e23fb0bfaff8d0a6db596adc7d29f259edd325e93bd33c/fdroidserver-0.7.0.tar.gz"
  sha256 "3de76a02d17260a5fd65b089ceaabcc578e238ffe71f205a8f6f37e705648d6e"

  bottle do
    sha256 "865ed32e2e747ff0a072aea1b81dcf4bea48f3b9c9e366cb4d755365175a8fb9" => :sierra
    sha256 "063793d45d71d58dba7b3fde83782b647efabfb047590536cb809d6bec350622" => :el_capitan
    sha256 "20c6fe3fa5c2ad4205e0a9ee3331f5191486024e77f798a98ba1a08d4fbc3552" => :yosemite
  end

  depends_on :python3
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "openssl"
  depends_on "android-sdk" => :recommended

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/d3/44/847e2e81da096b89ef56cb1c66093e61b06a8e1262f8ea2a76358e0d7b65/apache-libcloud-1.3.0.tar.bz2"
    sha256 "3b74fa9ee317b9e744f25fe2381c4a582545fe1259d133afc5a660b935a9861b"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/03/1a/60984cb85cc38c4ebdfca27b32a6df6f1914959d8790f5a349608c78be61/cryptography-1.5.2.tar.gz"
    sha256 "eb8875736734e8e870b09be43b17f40472dc189b1c422a952fa8580768204832"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/5c/bb/ab74c6914e3b570ab2e960fda17a01aec93474426eecd3b34751ba1c3b38/gitdb2-2.0.0.tar.gz"
    sha256 "b9f3209b401b8b4da5f94966c9c17650e66b7474ee5cd2dde5d983d1fba3ab66"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d7/16/e914d345d7d4e988f9196b9719a99220bad6a5dbd636162f9b5cc35f3bd6/GitPython-2.1.0.tar.gz"
    sha256 "3ebda1e6ff1ef68597e41dcd1b99c2a5ae902f4dc2b22ad3533cc89c32b42aad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "mwclient" do
    url "https://files.pythonhosted.org/packages/39/61/f743f760a720c4fd303192d12c3c8bd902543e7749a9efb1ba44b4ab0ead/mwclient-0.8.2.tar.gz"
    sha256 "e16fa5bc4fd1a2acfc5cc3897e7132500917198bd17350b543893c17abe2cbb6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/ce/92/7f07412a4f04e55c1e83a09c6fd48075b5df96c1dbd4078c3407c5be1dff/oauthlib-2.0.0.tar.gz"
    sha256 "0ad22b4f03fd75ef18d5793e1fed5e2361af5d374009f7722b4af390a0030dfd"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/46/4f/94f6165052774839b4a4af0c72071aa528d5dc8cb8bc6bb43e24a55c10cc/Pillow-3.4.2.tar.gz"
    sha256 "0ee9975c05602e755ff5000232e0335ba30d507f6261922a658ee11b1cec36d1"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/60/32/7703bccdba05998e4ff04db5038a6695a93bedc45dcf491724b85b5db76a/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/46/9b/c28061cc63298bc29ff7d668e18c5293bb522e946aaeb98e4c552d2c0f7b/requests-oauthlib-0.7.0.tar.gz"
    sha256 "198807c592b75438485c890f0403b1a8e363c86be1a87da687be18991a6850b0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/83/ce/e5b3aee7ca420b0ab24d4fcc2aa577f7aa6ea7e9306fafceabee3e8e4703/smmap2-2.0.1.tar.gz"
    sha256 "5c9fd3ac4a30b85d041a8bd3779e16aa704a161991e74b9a46692bc368e68752"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["freetype"].opt_include}/freetype2"
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
    doc.install "examples"
  end

  def caveats; <<-EOS.undent
    In order to function, fdroidserver requires that the Android SDK's
    "Build-tools" and "Platform-tools" are installed.  Also, it is best if the
    base path of the Android SDK is set in the standard environment variable
    ANDROID_HOME.  To install them from the command line, run:
    android update sdk --no-ui --all --filter tools,platform-tools,build-tools-25.0.0
    EOS
  end

  test do
    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath/"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      open("config.py", "w") do |f|
        f << "gradle = 'gradle'"
      end

      open("metadata/fake.txt", "w") do |f|
        f << "License:GPL\n"
        f << "Summary:Yup still fake\n"
        f << "Categories:Internet\n"
        f << "Description:\n"
        f << "this is fake\n"
        f << ".\n"
      end

      system "#{bin}/fdroid", "checkupdates", "--verbose"
      system "#{bin}/fdroid", "lint", "--verbose"
      system "#{bin}/fdroid", "rewritemeta", "fake", "--verbose"
      system "#{bin}/fdroid", "scanner", "--verbose"

      # TODO: enable once Android SDK build-tools are reliably installed
      # ENV["ANDROID_HOME"] = Formula["android-sdk"].opt_prefix
      # system "#{bin}/fdroid", "readmeta", "--verbose"
      # system "#{bin}/fdroid", "init", "--verbose"
      # assert File.exist?("config.py")
      # assert File.exist?("keystore.jks")
      # system "#{bin}/fdroid", "update", "--create-metadata", "--verbose"
      # assert File.exist?("metadata")
      # assert File.exist?("repo/index.jar")
    end
  end
end
