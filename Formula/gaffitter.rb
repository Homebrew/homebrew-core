class Gaffitter < Formula
  desc "Efficiently fit files/folders to fixed size volumes (like DVDs)"
  homepage "https://gaffitter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gaffitter/gaffitter/1.0.0/gaffitter-1.0.0.tar.gz"
  sha256 "c85d33bdc6c0875a7144b540a7cce3e78e7c23d2ead0489327625549c3ab23ee"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "669301900b6ced3cdd4e137fa2ca31e820ad5bda0581368ecb920d629c906edc"
    sha256 cellar: :any_skip_relocation, big_sur:       "59d1100a675e8b09edd424abee8c091c76e249118aa31d4a13a65196a217372b"
    sha256 cellar: :any_skip_relocation, catalina:      "a2381f4f6c482bc267117d445b342b599ec9fd67970a542bc1c680ece5e2cbfb"
    sha256 cellar: :any_skip_relocation, mojave:        "92257fd5e186c821139d66eea640bc3c64911046199faedc171564c62d7cef32"
    sha256 cellar: :any_skip_relocation, high_sierra:   "379feade37882f3b78accdda2131aa4530806d010f1fde6e879347c19a980786"
    sha256 cellar: :any_skip_relocation, sierra:        "9e2fbfd84ae7779882cbf3cd5d9a19fd9f27e6d986bd9c953df9a6e5687e242d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "1ca49d04fb786415d210d04e59c9e7ab74ada5ed6e2d429eb5793a3f34ba3562"
    sha256 cellar: :any_skip_relocation, yosemite:      "66332311c91a27aaf93d9bfa9d8d7c7c373aad98eb80ff53efebd3b9a0c51ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03da21621437817c39c5760eaf043615e7fe2d7653581763acc5ed87a71b2c6c"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"fit", "-t", "10m", "--show-size", testpath
  end
end
