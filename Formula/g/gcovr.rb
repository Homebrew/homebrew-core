class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/84/5d/75f6913653852720651790bf611e37355ee53cdd298c7f1561cde8773e02/gcovr-8.8.tar.gz"
  sha256 "0320230a432c033c1a41f34ba943082f450008c789bee05d414e532f380fd788"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfede2b0df62e8e982bc45a2f891e6809becfd22fb52324f80ee8c317a037556"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20ef4bc5d10ea700df93c319c420f663986a4c02dd3e2f2ce1f570669e0a3462"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1c7fcea0a995ac322e619866c38d32379d553ddf06cfe58567f9acfbb0aa71c"
    sha256 cellar: :any,                 arm64_linux:       "31a36ba0bae1c6503ed7fc75eb9396b4a3085d95d791c1645aa8725fd70783ea"
    sha256 cellar: :any,                 x86_64_linux:      "abd62c30b86859df50ea264e2480b6a67044bc78b2fde64f57e1cd4f67a39fbb"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write <<~C
      int main() {
        return 0;
      }
    C

    # gcov must match the c compiler version, which is gcc-12 on linux
    ENV["GCOV"] = ENV.cc.sub("gcc", "gcov") if OS.linux?
    system ENV.cc, "--coverage", "-g", "-O0", "-o", "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr")
  end
end
