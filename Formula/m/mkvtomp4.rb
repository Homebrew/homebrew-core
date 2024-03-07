class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://files.pythonhosted.org/packages/89/27/7367092f0d5530207e049afc76b167998dca2478a5c004018cf07e8a5653/mkvtomp4-2.0.tar.gz"
  sha256 "8514aa744963ea682e6a5c4b3cfab14c03346bfc78194c3cdc8b3a6317902f12"
  license "MIT"
  revision 3
  head "https://github.com/gavinbeatty/mkvtomp4.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12ce2a3b382ca7a2983051a1ad62e2a8f440b57f92a863036544b65ff1263a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03fef034ddc3444e057de70b4145a47562dff5a631abada7df4fee7c195d35ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98055a1447d0168c10b30e83ec972b5afb2fccb2abc6ff19f0cd5ebfc5439306"
    sha256 cellar: :any_skip_relocation, sonoma:         "1060a5f50089a0b0a0f9a2a0f34adcf4a083c800fea248897f42e2636561d9b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee6d01cacda55e7defde62d37a862e9f7add5d0fd0734879720ebc1ea2bebda"
    sha256 cellar: :any_skip_relocation, monterey:       "66134324e6af6ac8de9861bcfc8d1e4a2ef25808439d45121bb9822f669ff432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03d3794981d2717fbe2d7b2fd7d42ae8573a8b440bbf9dd8eaf6a0e3c91f0a6"
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bin.install_symlink "mkvtomp4.py" => "mkvtomp4"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
