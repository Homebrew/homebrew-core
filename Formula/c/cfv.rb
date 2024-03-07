class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/db/54/c5926a7846a895b1e096854f32473bcbdcb2aaff320995f3209f0a159be4/cfv-3.0.0.tar.gz"
  sha256 "2530f08b889c92118658ff4c447ccf83ac9d2973af8dae4d33cf5bed1865b376"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceda98b6735adc3c9ffb311d107f2e6852dfa2b1d95606dc2cbdbd1f9fe14957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00bd5bdcc3c6d07fa25f2740c6d4957e1dfbb69e12d1b5f5dcaa1b1b51215845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8a4205950b7ca03b64af3d346d4a62e2f92e2b9c62471eff4016b297b1f54bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "549e42b89e00ef86475782f6c3e4ab816ce34137a8bd3fbe1ca4f9bfe99e82b2"
    sha256 cellar: :any_skip_relocation, ventura:        "88a64151f0fd0e00d7c2ff56ed4ca792080fb2df54f536193c1870a598a13740"
    sha256 cellar: :any_skip_relocation, monterey:       "4d2f9326362dc6904d6ba58e018cf53462fb45d8430cfa8ddcd87509db93dfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8a066bcffd91118d3331e2a2b38759a56917957f9f4d32b9273c4091cce45c"
  end

  depends_on "python@3.12"

  def install
    # fix man folder location issue
    inreplace "setup.py", "'man/man1'", "'share/man/man1'"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
