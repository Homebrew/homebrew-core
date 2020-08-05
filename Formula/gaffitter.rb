class Gaffitter < Formula
  desc "Efficiently fit files/folders to fixed size volumes (like DVDs)"
  homepage "https://gaffitter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gaffitter/gaffitter/1.0.0/gaffitter-1.0.0.tar.gz"
  sha256 "c85d33bdc6c0875a7144b540a7cce3e78e7c23d2ead0489327625549c3ab23ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2381f4f6c482bc267117d445b342b599ec9fd67970a542bc1c680ece5e2cbfb" => :catalina
    sha256 "92257fd5e186c821139d66eea640bc3c64911046199faedc171564c62d7cef32" => :mojave
    sha256 "379feade37882f3b78accdda2131aa4530806d010f1fde6e879347c19a980786" => :high_sierra
    sha256 "9e2fbfd84ae7779882cbf3cd5d9a19fd9f27e6d986bd9c953df9a6e5687e242d" => :sierra
    sha256 "1ca49d04fb786415d210d04e59c9e7ab74ada5ed6e2d429eb5793a3f34ba3562" => :el_capitan
    sha256 "66332311c91a27aaf93d9bfa9d8d7c7c373aad98eb80ff53efebd3b9a0c51ff7" => :yosemite
    sha256 "be06c31a5074d00dbf23ef22f515a8f42855aebdf0f9ee1a592c0a2581ff8279" => :mavericks
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
