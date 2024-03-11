class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.5.8",
      revision: "7c9732329349f7619d0e108237e13be10f731c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "203daed71d50877bfb5941eb47d07d78de56a81acecc18f634f22132ef1dd8e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d98742680094ac37d47b87a1e42343ad833fa8d3d54df161792eb2ca042a47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd02d274663edf1d538af51ffffe6aebd5475c12c93b8c0d5725a9e90790187c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2841a2b24fa6fdfd9b7f26e81f1adf9caeb1fcbb37647266973489a9b015f1de"
    sha256 cellar: :any_skip_relocation, ventura:        "6d2f756d785ef54089e0ad6757c98b8ca6ebaf13c02faa07563eae52a60fd242"
    sha256 cellar: :any_skip_relocation, monterey:       "a68a752ed3186e3d3343b5b02755faf0fc07f03e51ac238257a8aa881c71eb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffbe5448d11be986043297fbc1e22e3f6256b5e5319f323fb5abafdf4779338"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  def install
    virtualenv_install_with_resources

    man1.install Dir["doc/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
