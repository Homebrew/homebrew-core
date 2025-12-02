class Gaffitter < Formula
  desc "Efficiently fit files/folders to fixed size volumes (like DVDs)"
  homepage "https://gaffitter.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gaffitter/gaffitter/1.0.0/gaffitter-1.0.0.tar.gz"
  sha256 "c85d33bdc6c0875a7144b540a7cce3e78e7c23d2ead0489327625549c3ab23ee"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ec8f9b01a9b1fff4a2d4cdfb51df68589b7574dcd825f9f6895e0083fe3901f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "99ba8c060b64df92ba624ecdf846c053658ff42c15d92221a79e705e664057bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9db231f5fd261b380cc7ef6840714a66e286bb3ad67c9643942d1d62eb79798d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b595fd07d59d03c35c504d66778fa5c6f0f245a37841c3155b7048463963f6f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e11de8d834a08f671619bf1c32bc7f3187243089e281ae6741728369c2a6abe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "669301900b6ced3cdd4e137fa2ca31e820ad5bda0581368ecb920d629c906edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "283647aa4787df613fe2c408696a2ce3517391d50afab41336ef35a93e982670"
    sha256 cellar: :any_skip_relocation, ventura:        "8334784dfa8795b86f4a542de4e5e70e3ed1d9985b06ae68c90560ed592e116d"
    sha256 cellar: :any_skip_relocation, monterey:       "0f766c5240ed9824f0cb041a3de1c8ea8d170586c4c248b3289ae9a3c9793745"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d1100a675e8b09edd424abee8c091c76e249118aa31d4a13a65196a217372b"
    sha256 cellar: :any_skip_relocation, catalina:       "a2381f4f6c482bc267117d445b342b599ec9fd67970a542bc1c680ece5e2cbfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7932b1fe151d9f7ac8a018292fd05a15b2e0ae8204b553e6cca6767ce54e409f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03da21621437817c39c5760eaf043615e7fe2d7653581763acc5ed87a71b2c6c"
  end

  depends_on "cmake" => :build

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"fit", "-t", "10m", "--show-size", testpath
  end
end
