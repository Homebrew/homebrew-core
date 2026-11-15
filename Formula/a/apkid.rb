class Apkid < Formula
  include Language::Python::Virtualenv

  desc "Android application identifier for compilers, packers, and obfuscators"
  homepage "https://github.com/rednaga/APKiD"
  url "https://files.pythonhosted.org/packages/f5/16/f354c98176e0e60e68ba5e8e4748063c43287d40482a6ccfd50acabd3c5f/apkid-3.2.0.tar.gz"
  sha256 "e812cf362672450f25941b3a38974c8e99d6e59e091d0a047ac05677c2b0d162"
  license "GPL-3.0-only"
  head "https://github.com/rednaga/APKiD.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "3195941c4d6ecf513f63a725621221513c4e2a60f9f2883d4f14807c56c8e523"
    sha256 arm64_tahoe:       "39975317af3bb7e15840124c81e8466ae8d5e587ac4f2e4f9ec96993264623f3"
    sha256 arm64_sequoia:     "7ba7adc981bdc5af666100300b80a5f83dfaedcc6ee1c7fe526310e7b9f582cf"
    sha256 arm64_linux:       "ea2fcec4a31623d23456922396ebcadb1ec798a314eb69b63f4ef329871b340a"
    sha256 x86_64_linux:      "896b8bf3a1a8a4cbe8c26b61623f1aae66d7d2819c14951d3e5d3e31a9f3451b"
  end

  depends_on "python@3.15"
  depends_on "yara"

  # `yara-python-dex` has no recent sdist; link `yara-python` to Homebrew's `yara`, which enables DEX
  pypi_packages exclude_packages: "yara-python-dex",
                extra_packages:   "yara-python"

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  # The PyPI sdist only ships `rules.yarc` compiled with YARA 3.x, so rebuild it from the rule sources
  resource "apkid-rules" do
    url "https://github.com/rednaga/APKiD/archive/refs/tags/v3.2.0.tar.gz"
    sha256 "7898ef35dcbd367fe6d4311478ce133ca81cb861c0e8a111c00f2d5f3c88f57d"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :build

  def install
    venv = virtualenv_install_with_resources without: %w[apkid-rules yara-python]

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end

    rules = venv.site_packages/"apkid/rules"
    resource("apkid-rules").stage { rules.install Dir["apkid/rules/*"] }
    system libexec/"bin/python", "-c", <<~PYTHON, rules
      import sys
      from apkid.rules import RulesManager
      manager = RulesManager(sys.argv[1])
      manager.compile()
      manager.save()
    PYTHON
  end

  test do
    apk = testpath/"test.apk"
    system python3, "-c", <<~PYTHON, apk
      import sys
      import zipfile
      with zipfile.ZipFile(sys.argv[1], "w") as archive:
          archive.writestr("AndroidManifest.xml", "manifest")
          archive.writestr("assets/AndroidManifest.xml", "manifest")
    PYTHON

    output = shell_output("#{bin}/apkid --json #{apk}")
    assert_match "apkid_version", output

    yara_rule = testpath/"test.yara"
    yara_rule.write <<~YARA
      import "dex"

      rule test {
        strings:
          $a = "marker"
        condition:
          $a
      }
    YARA
    result = shell_output(
      "#{libexec}/bin/python -c 'import sys, yara; " \
      "print(yara.compile(filepath=sys.argv[1]).match(data=\"marker\")[0].rule)' #{yara_rule}",
    )
    assert_equal "test", result.strip
  end
end
