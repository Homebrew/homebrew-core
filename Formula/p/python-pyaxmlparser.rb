class PythonPyaxmlparser < Formula
  desc "Parser for Android XML file and get Application Name without using Androguard"
  homepage "https://github.com/appknox/pyaxmlparser"
  url "https://files.pythonhosted.org/packages/58/7f/327c19329f535c332451b5f1f906bff5f952fe3070d00376b75e67052f35/pyaxmlparser-0.3.28.tar.gz"
  sha256 "c482826380fd84ce1a6386183861f2a6728017241a230c13d521e3e7737e803e"
  license "Apache-2.0"

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-asn1crypto"
  depends_on "python-click"
  depends_on "python-lxml"

  # fix man path
  # upstream PR ref, https://github.com/appknox/pyaxmlparser/pull/72
  patch do
    url "https://github.com/appknox/pyaxmlparser/commit/1733e27ed71c249f9d7b0642439e56dbb6be2742.patch?full_index=1"
    sha256 "f2a516abd5cc82fe19da563a1cad4d6bc5face34b88a6a827aa09439107c1041"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `apkinfo`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkinfo #{testpath}/redex-test.apk")
    assert_match <<~EOS, output
      App name: RedexTest
      Package: com.facebook.redex.test.instr
      Version name: 1.0
      Version code: 1
      Is it Signed: True
      Is it Signed with v1 Signatures: True
      Is it Signed with v2 Signatures: False
      Is it Signed with v3 Signatures: False
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from pyaxmlparser import APK"
    end
  end
end
