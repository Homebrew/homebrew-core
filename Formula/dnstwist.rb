class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/c2/92/19699296526b934f9e0a0b79ad2d5ea5582c5fc96da588380c92a4398b14/dnstwist-20211204.tar.gz"
  sha256 "5aa0b3da834d0b207521e0cf81500317b698e23763d6c872511644d713a08994"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2db2d67e7e690d4c92dc9e0407ffc376f9983fefc22c039e29abc19de4c2f89c"
    sha256 cellar: :any,                 arm64_big_sur:  "bf760c8372a1f9683c4e286e1e33478b1b5cbf34a68161d19c0da008f764343c"
    sha256 cellar: :any,                 monterey:       "26fdf9cea3eed158bc4a290b30aa85312cf955afa2ec80e9f89f6dfbc6d40f94"
    sha256 cellar: :any,                 big_sur:        "db37fce3570b0b571f2683c4c088fdfc27df598bb164e4fac250ab208daa2a97"
    sha256 cellar: :any,                 catalina:       "04921cc3f53ea9e9cad458167fadfcc9f60e1b9c76e81954ee21b8f26ad51a5e"
    sha256 cellar: :any,                 mojave:         "188c9b6cfd70f1cd4f2921b6b0fe71b224f46949b67d292ba28e9bcf6fd8399b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63af2a88affd5f0f06ca0d41a5998e3b8d3cb7e206f587a5645861a9e0aa59cb"
  end

  depends_on "geoip"
  depends_on "python@3.10"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", PATH: "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist -rsw --thread=1 brew.sh")

    assert_match version.to_s, output
    assert_match "Fetching content from:", output
    assert_match "//brew.sh", output
    assert_match(/Processing \d+ permutations/, output)
    refute_match(/notice: missing module/, output)
  end
end
