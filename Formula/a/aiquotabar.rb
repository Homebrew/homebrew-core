class Aiquotabar < Formula
  desc "macOS menu bar app showing live Claude.ai and ChatGPT usage limits"
  homepage "https://github.com/yagcioglutoprak/AIQuotaBar"
  url "https://github.com/yagcioglutoprak/AIQuotaBar/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9c875f01e4891e4483640abcf1447e172dcf66ddfc49f46df91187ea19c4f5ff"
  license "MIT"
  head "https://github.com/yagcioglutoprak/AIQuotaBar.git", branch: "main"

  depends_on macos: :monterey
  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/af/2d/7bf41579a8986e348fa033a31cdd0e4121114f6bce2457e8876010b092dd/certifi-2026.2.25.tar.gz"
    sha256 "e887ab5cee78ea814d3472169153c2d12cd43b14bd03329a39a9c6e2e80bfba7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/9b/c9/0067d9a25ed4592b022d4558157fcdb6e123516083700786d38091688767/curl_cffi-0.14.0.tar.gz"
    sha256 "5ffbc82e59f05008ec08ea432f0e535418823cda44178ee518906a54f27a5f0f"
  end

  resource "lz4" do
    url "https://files.pythonhosted.org/packages/57/51/f1b86d93029f418033dddf9b9f79c8d2641e7454080478ee2aab5123173e/lz4-4.4.5.tar.gz"
    sha256 "5f0b9e53c1e82e88c10d7c180069363980136b9d7a8306c4dca4f760d60c39f0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "browser-cookie3" do
    url "https://files.pythonhosted.org/packages/e0/e1/652adea0ce25948e613ef78294c8ceaf4b32844aae00680d3a1712dde444/browser_cookie3-0.20.1.tar.gz"
    sha256 "6d8d0744bf42a5327c951bdbcf77741db3455b8b4e840e18bab266d598368a12"
  end

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/b2/e2/2e6a47951290bd1a2831dcc50aec4b25d104c0cf00e8b7868cbd29cf3bfe/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  def install
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv

    resources.each do |r|
      r.stage do
        system venv/"bin/pip", "install", "--no-deps", "."
      end
    end

    libexec.install "claude_bar.py"
    (libexec/"assets").install Dir["assets/*"]

    # Fix rumps notification crash (requires CFBundleIdentifier in Info.plist)
    plist_path = venv/"bin/Info.plist"
    unless plist_path.exist?
      system "/usr/libexec/PlistBuddy", "-c",
             "Add :CFBundleIdentifier string rumps", plist_path.to_s
    end

    (bin/"aiquotabar").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/python" "#{libexec}/claude_bar.py" "$@"
    SH
    chmod 0755, bin/"aiquotabar"
  end

  def caveats
    <<~EOS
      AIQuotaBar is a macOS menu bar app. Launch it with:
        aiquotabar &

      To run it at login, click the ◆ icon in your menu bar → Launch at Login.

      Logs are written to: ~/.claude_bar.log
    EOS
  end

  test do
    system "#{libexec}/venv/bin/python", "-m", "py_compile", "#{libexec}/claude_bar.py"
  end
end
